require 'json'

module Prometheus
  module Client
    module Helper
      module JsonParser
        class << self
          if defined?(Oj)
            def load(s)
              Oj.load(s)
            end
          else
            def load(s)
              JSON.parse(s)
            end
          end
        end
      end
    end
  end
end
