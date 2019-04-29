// have to be included first as they violate our poisons
#include "cfg/proto/proto.h"

#include "core/proto/proto.h"

using namespace std;

namespace sorbet::cfg {

com::stripe::rubytyper::CFG Proto::toProto(const core::GlobalState &gs, const cfg::CFG &cfg) {
    com::stripe::rubytyper::CFG proto;
    *proto.mutable_symbol() = core::Proto::toProto(gs, cfg.symbol);
    return proto;
}

} // namespace sorbet::core
