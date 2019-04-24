require 'rubocop-rspec'

module Gitlab
  module Styles
    module Rubocop
      module Cop
        module RSpec
          # This cop checks for unused parameters to the `have_link` matcher.
          #
          # @example
          #
          #   # bad
          #   expect(page).to have_link('Link', 'https://example.com')
          #
          #   # good
          #   expect(page).to have_link('Link', href: 'https://example.com')
          #   expect(page).to have_link('Example')
          class HaveLinkParameters < RuboCop::Cop::RSpec::Cop
            MESSAGE = "The second argument to `have_link` should be a Hash.".freeze

            def_node_matcher :unused_parameters?, <<~PATTERN
              (send nil? :have_link
                _ !{hash nil}
              )
            PATTERN

            def on_send(node)
              return unless unused_parameters?(node)

              location = node.arguments[1..-1]
                .map(&:source_range)
                .reduce(:join)

              add_offense(node, location: location, message: MESSAGE)
            end
          end
        end
      end
    end
  end
end
