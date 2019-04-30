// have to be included first as they violate our poisons
#include "cfg/proto/proto.h"

#include "core/proto/proto.h"

using namespace std;

namespace sorbet::cfg {

com::stripe::rubytyper::TypedVariable Proto::toProto(const core::GlobalState &gs, const cfg::VariableUseSite &vus) {
    com::stripe::rubytyper::TypedVariable proto;
    // TODO: Is `shortName` really what we want?
    auto const &name = vus.variable._name.data(gs);
    proto.set_variable(std::string(name->shortName(gs)));
    return proto;
}


com::stripe::rubytyper::Binding Proto::toProto(const core::GlobalState &gs, const cfg::Binding &bnd) {
    com::stripe::rubytyper::Binding proto;
    *proto.mutable_bind() = toProto(gs, bnd.bind);
    return proto;
}

com::stripe::rubytyper::Block Proto::toProto(const core::GlobalState &gs, const cfg::BasicBlock &bb) {
    com::stripe::rubytyper::Block proto;
    proto.set_id(bb.id);
    for (auto const &bnd: bb.exprs) {
        *proto.add_bindings() = toProto(gs, bnd);
    }
    return proto;
}

com::stripe::rubytyper::CFG Proto::toProto(const core::GlobalState &gs, const cfg::CFG &cfg) {
    com::stripe::rubytyper::CFG proto;
    *proto.mutable_symbol() = core::Proto::toProto(gs, cfg.symbol);
    for (auto const &block: cfg.basicBlocks) {
        *proto.add_blocks() = toProto(gs, *block);
    }
    return proto;
}

} // namespace sorbet::core
