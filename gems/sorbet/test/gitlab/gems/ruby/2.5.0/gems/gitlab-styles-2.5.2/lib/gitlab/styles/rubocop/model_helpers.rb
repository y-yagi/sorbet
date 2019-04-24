module Gitlab
  module Styles
    module Rubocop
      module ModelHelpers
        # Returns true if the given node originated from the models directory.
        def in_model?(node)
          path = node.location.expression.source_buffer.name
          pwd = Dir.pwd
          models_path = File.join(pwd, 'app', 'models')
          ee_models_path = File.join(pwd, 'ee', 'app', 'models')

          path.start_with?(models_path, ee_models_path)
        end
      end
    end
  end
end
