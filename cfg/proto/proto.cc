// have to be included first as they violate our poisons
#include "cfg/proto/proto.h"

#include "core/proto/proto.h"

using namespace std;

namespace sorbet::cfg {

// TODO: We don't want to see children of our owners, that just gets silly
static com::stripe::rubytyper::Symbol symbolNoChildren(core::Context ctx, core::SymbolRef sym) {
    auto proto = core::Proto::toProto(ctx.state, sym);
    proto.clear_children();
    return proto;
}


static void addOwners(core::Context ctx, com::stripe::rubytyper::OwnedSymbol &proto, core::SymbolRef sym) {
    if (sym.exists() && sym != core::Symbols::root()) {
        addOwners(ctx, proto, sym.data(ctx.state)->owner);
        *proto.add_owners() = symbolNoChildren(ctx, sym);
    }
}

com::stripe::rubytyper::OwnedSymbol Proto::ownedSymbolProto(core::Context ctx, core::SymbolRef sym) {
    com::stripe::rubytyper::OwnedSymbol proto;
    *proto.mutable_symbol() = core::Proto::toProto(ctx.state, sym);
    addOwners(ctx, proto, sym.data(ctx.state)->owner);
    return proto;
}

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

com::stripe::rubytyper::BlockExit Proto::toProto(core::Context ctx, const BlockExit &ex) {
    com::stripe::rubytyper::BlockExit proto;
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

com::stripe::rubytyper::CFG Proto::toProto(core::Context ctx, const CFG &cfg) {
    com::stripe::rubytyper::CFG proto;
    *proto.mutable_symbol() = ownedSymbolProto(ctx, cfg.symbol);
    for (auto const &block: cfg.basicBlocks) {
        *proto.add_blocks() = toProto(ctx, *block);
    }
    return proto;
}

} // namespace sorbet::cfg
