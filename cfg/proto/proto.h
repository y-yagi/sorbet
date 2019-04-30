#ifndef SORBET_CFG_PROTO_H
#define SORBET_CFG_PROTO_H
// have to go first as they violate our poisons
#include "proto/CFG.pb.h"

#include "cfg/CFG.h"

namespace sorbet::cfg {
    class Proto {
    public:
        Proto() = delete;

        static com::stripe::rubytyper::TypedVariable toProto(const core::GlobalState &gs, const cfg::VariableUseSite &vus);
        static com::stripe::rubytyper::Binding toProto(const core::GlobalState &gs, const cfg::Binding &bnd);
        static com::stripe::rubytyper::Block toProto(const core::GlobalState &gs, const cfg::BasicBlock &bb);
        static com::stripe::rubytyper::CFG toProto(const core::GlobalState &gs, const cfg::CFG &cfg);
    };
} // namespace sorbet::core

#endif
