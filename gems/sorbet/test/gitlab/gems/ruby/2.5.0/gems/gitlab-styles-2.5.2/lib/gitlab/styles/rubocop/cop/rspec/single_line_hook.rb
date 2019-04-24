require 'rubocop-rspec'

module Gitlab
  module Styles
    module Rubocop
      module Cop
        module RSpec
          # This cop checks for single-line hook blocks
          #
          # @example
          #
          #   # bad
          #   before { do_something }
          #   after(:each) { undo_something }
          #
          #   # good
          #   before do
          #     do_something
          #   end
          #
          #   after(:each) do
          #     undo_something
          #   end
          class SingleLineHook < RuboCop::Cop::RSpec::Cop
            MESSAGE = "Don't use single-line hook blocks.".freeze

            def_node_search :rspec_hook?, <<~PATTERN
              (send nil? {:after :around :before} ...)
            PATTERN

            def on_block(node)
              return unless node.single_line?
              return unless rspec_hook?(node)

              add_offense(node, location: :expression, message: MESSAGE)
            end
          end
        end
      end
    end
  end
end
