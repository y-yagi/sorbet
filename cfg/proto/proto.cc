// have to be included first as they violate our poisons
#include "cfg/proto/proto.h"

#include "core/proto/proto.h"

using namespace std;

namespace sorbet::cfg {

com::stripe::rubytyper::TypedVariable Proto::toProto(core::Context ctx, const VariableUseSite &vus) {
    com::stripe::rubytyper::TypedVariable proto;
    if (vus.variable._name.exists()) {
        *proto.mutable_variable() = core::Proto::toProto(ctx.state, vus.variable._name);
    }
    if (vus.type) {
        proto.set_tmp_type(vus.type->show(ctx.state));
    }
    return proto;
}

com::stripe::rubytyper::Binding Proto::toProto(core::Context ctx, const Binding &bnd) {
    com::stripe::rubytyper::Binding proto;
    *proto.mutable_bind() = toProto(ctx, bnd.bind);
    proto.set_tmp_instruction(bnd.value->toString(ctx));
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
        proto.set_tmp_type(s->resultType->show(ctx.state));
    }
    return proto;
}


com::stripe::rubytyper::CFG Proto::toProto(core::Context ctx, const CFG &cfg) {
    com::stripe::rubytyper::CFG proto;

    *proto.mutable_symbol() = core::Proto::toProto(ctx, cfg.symbol);

    core::SymbolData sym = cfg.symbol.data(ctx.state);
    core::TypePtr ty = sym->resultType;
    if (ty) {
        proto.set_tmp_return_type(ty->show(ctx.state));
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
