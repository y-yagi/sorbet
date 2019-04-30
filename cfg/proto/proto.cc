// have to be included first as they violate our poisons
#include "cfg/proto/proto.h"

#include "core/proto/proto.h"

using namespace std;

namespace sorbet::cfg {

com::stripe::rubytyper::TypedVariable Proto::toProto(core::Context ctx, const cfg::VariableUseSite &vus) {
    com::stripe::rubytyper::TypedVariable proto;
    // TODO: Is `shortName` really what we want?
    auto const &nameRef = vus.variable._name;
    if (nameRef.exists()) {
        auto const &name = nameRef.data(ctx.state);
        auto const &shortName = name->shortName(ctx.state);
        proto.set_variable(std::string(shortName));
    }
    if (vus.type) {
        proto.set_tmp_type(vus.type->show(ctx.state));
    }
    return proto;
}

com::stripe::rubytyper::Binding Proto::toProto(core::Context ctx, const cfg::Binding &bnd) {
    com::stripe::rubytyper::Binding proto;
    *proto.mutable_bind() = toProto(ctx, bnd.bind);
    proto.set_tmp_instruction(bnd.value->toString(ctx));
    return proto;
}

com::stripe::rubytyper::BlockExit Proto::toProto(core::Context ctx, const cfg::BlockExit &ex) {
    com::stripe::rubytyper::BlockExit proto;
    if (ex.isCondSet()) {
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

com::stripe::rubytyper::Block Proto::toProto(core::Context ctx, const cfg::BasicBlock &bb) {
    com::stripe::rubytyper::Block proto;
    proto.set_id(bb.id);
    for (auto const &bnd: bb.exprs) {
        *proto.add_bindings() = toProto(ctx, bnd);
    }
    *proto.mutable_exit() = toProto(ctx, bb.bexit);
    return proto;
}

com::stripe::rubytyper::CFG Proto::toProto(core::Context ctx, const cfg::CFG &cfg) {
    com::stripe::rubytyper::CFG proto;
    *proto.mutable_symbol() = core::Proto::toProto(ctx.state, cfg.symbol);
    for (auto const &block: cfg.basicBlocks) {
        *proto.add_blocks() = toProto(ctx, *block);
    }
    return proto;
}

} // namespace sorbet::core
