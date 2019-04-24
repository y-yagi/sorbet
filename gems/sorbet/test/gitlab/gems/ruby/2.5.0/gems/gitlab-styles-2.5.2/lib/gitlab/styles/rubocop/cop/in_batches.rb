require_relative '../model_helpers'

module Gitlab
  module Styles
    module Rubocop
      module Cop
        # Cop that prevents the use of `in_batches`
        class InBatches < RuboCop::Cop::Cop
          MSG = 'Do not use `in_batches`, use `each_batch` from the EachBatch module instead'.freeze

          def on_send(node)
            return unless node.children[1] == :in_batches

            add_offense(node, location: :selector)
          end
        end
      end
    end
  end
end
