#include "ast/ast.h"
#include "ast/treemap/treemap.h"
#include "core/core.h"
#include "core/errors/resolver.h"

#include "absl/algorithm/container.h"

using namespace std;

namespace sorbet::definition_validator {

struct Signature {
    struct {
        absl::InlinedVector<core::NameRef, 4> required;
        absl::InlinedVector<core::NameRef, 4> optional;
        std::optional<const core::ArgInfo *> rest;
    } pos, kw;
    bool syntheticBlk;
} left, right;

Signature decomposeSignature(const core::GlobalState &gs, core::SymbolRef method) {
    Signature sig;
    for (auto &arg : method.data(gs)->arguments()) {
        if (arg.flags.isBlock) {
            sig.syntheticBlk = arg.isSyntheticBlockArgument();
            continue;
        }

        auto &dst = arg.flags.isKeyword ? sig.kw : sig.pos;
        if (arg.flags.isRepeated) {
            dst.rest = std::optional<const core::ArgInfo *>{&arg};
        } else if (arg.flags.isDefault) {
            dst.optional.push_back(arg.name);
        } else {
            dst.required.push_back(arg.name);
        }
    }
    return sig;
}

// Eventually this should check the appropriate subtype relationships on types,
// as well, but for now we just look at the argument shapes and ensure that they
// are compatible.
void validateCompatibleOverride(const core::Context ctx, core::SymbolRef superMethod, core::SymbolRef method) {
    if (method.data(ctx)->isOverloaded()) {
        // Don't try to check overloaded methods; It's not immediately clear how
        // to match overloads against their superclass definitions. Since we
        // Only permit overloading in the stdlib for now, this is no great loss.
        return;
    }

    auto left = decomposeSignature(ctx, superMethod);
    auto right = decomposeSignature(ctx, method);

    if (!right.pos.rest) {
        auto leftPos = left.pos.required.size() + left.pos.optional.size();
        auto rightPos = right.pos.required.size() + right.pos.optional.size();
        if (leftPos > rightPos) {
            if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
                e.setHeader("Implementation of abstract method `{}` must accept at least `{}` positional arguments",
                            superMethod.data(ctx)->show(ctx), leftPos);
                e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here");
            }
        }
    }

    if (auto leftRest = left.pos.rest) {
        if (!right.pos.rest) {
            if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
                e.setHeader("Implementation of abstract method `{}` must accept *`{}`", superMethod.data(ctx)->show(ctx),
                            (*leftRest)->show(ctx));
                e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here");
            }
        }
    }

    if (right.pos.required.size() > left.pos.required.size()) {
        if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
            e.setHeader("Implementation of abstract method `{}` must accept no more than `{}` required argument(s)",
                        superMethod.data(ctx)->show(ctx), left.pos.required.size());
            e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here");
        }
    }

    if (!right.kw.rest) {
        for (auto req : left.kw.required) {
            if (absl::c_any_of(right.kw.required, [&](const auto &r) { return r == req; })) {
                continue;
            }
            if (absl::c_any_of(right.kw.optional, [&](const auto &r) { return r == req; })) {
                continue;
            }
            if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
                e.setHeader("Implementation of abstract method `{}` is missing required keyword argument `{}`",
                            superMethod.data(ctx)->show(ctx), req.show(ctx));
                e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here");
            }
        }
    }

    if (auto leftRest = left.kw.rest) {
        if (!right.kw.rest) {
            if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
                e.setHeader("Implementation of abstract method `{}` must accept **`{}`", superMethod.data(ctx)->show(ctx),
                            (*leftRest)->show(ctx));
                e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here");
            }
        }
    }

    for (auto extra : right.kw.required) {
        if (absl::c_any_of(left.kw.required, [&](const auto &l) { return l == extra; })) {
            continue;
        }
        if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
            e.setHeader("Implementation of abstract method `{}` contains extra required keyword argument `{}`",
                        superMethod.data(ctx)->show(ctx), extra.toString(ctx));
            e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here");
        }
    }

    if (!left.syntheticBlk && right.syntheticBlk) {
        if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
            e.setHeader("Implementation of abstract method `{}` must explicitly name a block argument",
                        superMethod.data(ctx)->show(ctx));
            e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here");
        }
    }

    {
        auto superReturn = superMethod.data(ctx)->resultType;
        if (!superReturn) {
            superReturn = core::Types::untyped(ctx, superMethod);
        }

        auto methodReturn = method.data(ctx)->resultType;
        if (!methodReturn) {
            methodReturn = core::Types::untyped(ctx, method);
        }

        if (!superMethod.data(ctx)->isGenericMethod() && superReturn->isFullyDefined() && methodReturn->isFullyDefined() && !core::Types::isSubType(ctx, methodReturn, superReturn)) {
            if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadMethodOverride)) {
                e.setHeader("Return type `{}` does not match return type of abstract method `{}`",
                            methodReturn->show(ctx),
                            superMethod.data(ctx)->show(ctx));
                e.addErrorLine(superMethod.data(ctx)->loc(), "Base method defined here with return type `{}`",
                               superReturn->show(ctx));
            }
        }

    }
}

void validateOverriding(const core::Context ctx, core::SymbolRef method) {
    auto klass = method.data(ctx)->owner;
    auto name = method.data(ctx)->name;
    ENFORCE(klass.data(ctx)->isClass());
    auto klassData = klass.data(ctx);
    InlinedVector<core::SymbolRef, 4> overridenMethods;

    // both of these match the behavior of the runtime checks, which will only allow public methods to be defined in
    // interfaces
    if (klassData->isClassInterface() && method.data(ctx)->isPrivate()) {
        if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::NonPublicAbstract)) {
            e.setHeader("Interface method `{}` cannot be private", method.show(ctx));
        }
    }

    if (klassData->isClassInterface() && method.data(ctx)->isProtected()) {
        if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::NonPublicAbstract)) {
            e.setHeader("Interface method `{}` cannot be protected", method.show(ctx));
        }
    }

    if (method.data(ctx)->isAbstract() && klassData->isClass() && klassData->isSingletonClass(ctx)) {
        auto attached = klassData->attachedClass(ctx);
        if (attached.exists() && attached.data(ctx)->isClassModule()) {
            if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::BadAbstractMethod)) {
                e.setHeader("Static methods in a module cannot be abstract");
            }
        }
    }

    if (klassData->superClass().exists()) {
        auto superMethod = klassData->superClass().data(ctx)->findMemberTransitive(ctx, name);
        if (superMethod.exists()) {
            overridenMethods.emplace_back(superMethod);
        }
    }
    for (const auto &mixin : klassData->mixins()) {
        auto superMethod = mixin.data(ctx)->findMember(ctx, name);
        if (superMethod.exists()) {
            overridenMethods.emplace_back(superMethod);
        }
    }

    for (const auto &overridenMethod : overridenMethods) {
        if (overridenMethod.data(ctx)->isFinalMethod()) {
            if (auto e = ctx.state.beginError(method.data(ctx)->loc(), core::errors::Resolver::OverridesFinal)) {
                e.setHeader("Method overrides a final method `{}`", overridenMethod.data(ctx)->show(ctx));
                e.addErrorLine(overridenMethod.data(ctx)->loc(), "defined here");
            }
        }
        if ((overridenMethod.data(ctx)->isAbstract() || overridenMethod.data(ctx)->isOverridable()) &&
            !method.data(ctx)->isIncompatibleOverride()) {
            validateCompatibleOverride(ctx, overridenMethod, method);
        }
    }
}

class ValidateWalk {
private:
    UnorderedMap<core::SymbolRef, vector<core::SymbolRef>> abstractCache;

    const vector<core::SymbolRef> &getAbstractMethods(const core::GlobalState &gs, core::SymbolRef klass) {
        vector<core::SymbolRef> abstract;
        auto ent = abstractCache.find(klass);
        if (ent != abstractCache.end()) {
            return ent->second;
        }

        auto superclass = klass.data(gs)->superClass();
        if (superclass.exists()) {
            auto &superclassMethods = getAbstractMethods(gs, superclass);
            // TODO(nelhage): This code coud go quadratic or even exponential given
            // pathological arrangments of interfaces and abstract methods. Switch
            // to a better data structure if that is ever a problem.
            abstract.insert(abstract.end(), superclassMethods.begin(), superclassMethods.end());
        }

        for (auto ancst : klass.data(gs)->mixins()) {
            auto fromMixin = getAbstractMethods(gs, ancst);
            abstract.insert(abstract.end(), fromMixin.begin(), fromMixin.end());
        }

        auto isAbstract = klass.data(gs)->isClassAbstract();
        if (isAbstract) {
            for (auto mem : klass.data(gs)->members()) {
                if (mem.second.data(gs)->isMethod() && mem.second.data(gs)->isAbstract()) {
                    abstract.emplace_back(mem.second);
                }
            }
        }

        auto &entry = abstractCache[klass];
        entry = std::move(abstract);
        return entry;
    }

    // if/when we get final classes, we can just mark subclasses of `T::Struct` as final and essentially subsume the
    // logic here.
    void validateTStructNotGrandparent(const core::GlobalState &gs, core::SymbolRef sym) {
        auto parent = sym.data(gs)->superClass();
        if (!parent.exists()) {
            return;
        }
        auto grandparent = parent.data(gs)->superClass();
        if (!grandparent.exists() || grandparent != core::Symbols::T_Struct()) {
            return;
        }
        if (auto e = gs.beginError(sym.data(gs)->loc(), core::errors::Resolver::SubclassingNotAllowed)) {
            auto parentName = parent.data(gs)->show(gs);
            e.setHeader("Subclassing `{}` is not allowed", parentName);
            e.addErrorLine(parent.data(gs)->loc(), "`{}` is a subclass of `T::Struct`", parentName);
        }
    }

    void validateAbstract(const core::GlobalState &gs, core::SymbolRef sym) {
        if (sym.data(gs)->isClassAbstract()) {
            return;
        }
        auto loc = sym.data(gs)->loc();
        if (loc.exists() && loc.file().data(gs).isRBI()) {
            return;
        }

        auto &abstract = getAbstractMethods(gs, sym);

        if (abstract.empty()) {
            return;
        }

        for (auto proto : abstract) {
            if (proto.data(gs)->owner == sym) {
                continue;
            }

            auto mem = sym.data(gs)->findConcreteMethodTransitive(gs, proto.data(gs)->name);
            if (!mem.exists()) {
                if (auto e = gs.beginError(loc, core::errors::Resolver::BadAbstractMethod)) {
                    e.setHeader("Missing definition for abstract method `{}`", proto.data(gs)->show(gs));
                    e.addErrorLine(proto.data(gs)->loc(), "defined here");
                }
            }
        }
    }

public:
    unique_ptr<ast::ClassDef> preTransformClassDef(core::Context ctx, unique_ptr<ast::ClassDef> classDef) {
        auto sym = classDef->symbol;
        validateAbstract(ctx.state, sym);
        validateTStructNotGrandparent(ctx.state, sym);
        auto singleton = sym.data(ctx)->lookupSingletonClass(ctx);
        validateAbstract(ctx.state, singleton);
        return classDef;
    }

    unique_ptr<ast::MethodDef> preTransformMethodDef(core::Context ctx, unique_ptr<ast::MethodDef> methodDef) {
        validateOverriding(ctx, methodDef->symbol);
        return methodDef;
    }
};

ast::ParsedFile runOne(core::Context ctx, ast::ParsedFile tree) {
    Timer timeit(ctx.state.tracer(), "validateSymbols");

    ValidateWalk validate;
    tree.tree = ast::TreeMap::apply(ctx, validate, std::move(tree.tree));
    return tree;
}

} // namespace sorbet::definition_validator
