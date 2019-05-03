// have to be included first as they violate our poisons
#include "cfg/proto/proto.h"

#include "core/proto/proto.h"

using namespace std;

namespace sorbet::cfg {

com::stripe::rubytyper::TypedVariable Proto::toProto(core::Context ctx, const VariableUseSite &vus) {
    com::stripe::rubytyper::TypedVariable proto;
    proto.set_name(vus.variable.toString(ctx.state));
    if (vus.type) {
        *proto.mutable_type() = core::Proto::toProto(ctx.state, vus.type);
    }
    return proto;
}

com::stripe::rubytyper::Instruction Proto::toProto(core::Context ctx, const Instruction *instr) {
    com::stripe::rubytyper::Instruction proto;
    typecase(instr,
         [&](const Ident *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::IDENT);
             proto.set_ident(i->what.toString(ctx.state));
         },
         [&](const Alias *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::ALIAS);
         },
         [&](const SolveConstraint *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::SEND);
         },
         [&](const Send *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::SEND);
         },
         [&](const Return *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::RETURN);
         },
         [&](const LoadSelf *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::LOAD_SELF);
         },
         [&](const Literal *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::LITERAL);
         },
         [&](const Unanalyzable *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::UNANALYZABLE);
         },
         [&](const LoadArg *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::LOAD_ARG);
         },
         [&](const Cast *i) {
             proto.set_kind(com::stripe::rubytyper::Instruction::CAST);
         },
        // TODO later: add more types
        [&](const Instruction *i) {
            proto.set_kind(com::stripe::rubytyper::Instruction::UNKNOWN);
        }
    );
    return proto;
}

com::stripe::rubytyper::Binding Proto::toProto(core::Context ctx, const Binding &bnd) {
    com::stripe::rubytyper::Binding proto;
    *proto.mutable_bind() = toProto(ctx, bnd.bind);
    *proto.mutable_instruction() = toProto(ctx, bnd.value.get());
    return proto;
}

com::stripe::rubytyper::Block::BlockExit Proto::toProto(core::Context ctx, const BlockExit &ex) {
    com::stripe::rubytyper::Block::BlockExit proto;
    if (ex.cond.variable.exists()) {
        *proto.mutable_cond() = toProto(ctx, ex.cond);
    }
    if (ex.thenb) {
        proto.set_then_block(ex.thenb->id);
    }
    if (ex.elseb) {
        proto.set_else_block(ex.elseb->id);
    }
    return proto;
}

com::stripe::rubytyper::Block Proto::toProto(core::Context ctx, const BasicBlock &bb) {
    com::stripe::rubytyper::Block proto;
    proto.set_id(bb.id);
    for (auto const &bnd: bb.exprs) {
        *proto.add_bindings() = toProto(ctx, bnd);
    }
    *proto.mutable_exit() = toProto(ctx, bb.bexit);
    return proto;
}

com::stripe::rubytyper::CFG::Argument Proto::argumentToProto(core::Context ctx, core::SymbolRef sym) {
    com::stripe::rubytyper::CFG::Argument proto;

    core::SymbolData s = sym.data(ctx.state);
    proto.set_name(s->argumentName(ctx.state));
    if (s->resultType) {
        *proto.mutable_type() = core::Proto::toProto(ctx.state, s->resultType);
    }
    return proto;
}


com::stripe::rubytyper::CFG Proto::toProto(core::Context ctx, const CFG &cfg) {
    com::stripe::rubytyper::CFG proto;

    *proto.mutable_symbol() = core::Proto::toProto(ctx, cfg.symbol);

    core::SymbolData sym = cfg.symbol.data(ctx.state);
    if (sym->resultType) {
        *proto.mutable_returns() = core::Proto::toProto(ctx.state, sym->resultType);
    }

    for (auto arg: sym->arguments()) {
        *proto.add_arguments() = argumentToProto(ctx, arg);
    }

    for (auto const &block: cfg.basicBlocks) {
        *proto.add_blocks() = toProto(ctx, *block);
    }
    return proto;
}

} // namespace sorbet::cfg
