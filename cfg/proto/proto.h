#ifndef SORBET_CFG_PROTO_H
#define SORBET_CFG_PROTO_H
// have to go first as they violate our poisons
#include "proto/CFG.pb.h"

#include "cfg/CFG.h"

namespace sorbet::cfg {
    class Proto {
    public:
        Proto() = delete;

        static com::stripe::rubytyper::TypedVariable toProto(core::Context ctx, const VariableUseSite &vus);

        static com::stripe::rubytyper::Binding toProto(core::Context ctx, const Binding &bnd);

        static com::stripe::rubytyper::Block::BlockExit toProto(core::Context ctx, const BlockExit &ex);
        static com::stripe::rubytyper::Block toProto(core::Context ctx, const BasicBlock &bb);

        static com::stripe::rubytyper::CFG::Argument argumentToProto(core::Context ctx, core::SymbolRef sym);
        static com::stripe::rubytyper::CFG toProto(core::Context ctx, const CFG &cfg);
    };
} // namespace sorbet::cfg

#endif
