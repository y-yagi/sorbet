require 'prometheus/client/registry'
require 'prometheus/client/configuration'
require 'prometheus/client/mmaped_value'

module Prometheus
  # Client is a ruby implementation for a Prometheus compatible client.
  module Client
    class << self
      attr_writer :configuration

      def configuration
        @configuration ||= Configuration.new
      end

      def configure
        yield(configuration)
      end

      # Returns a default registry object
      def registry
        @registry ||= Registry.new
      end

      def logger
        configuration.logger
      end

      def pid
        configuration.pid_provider.call
      end

      def reset!
        @registry = nil
        ::Prometheus::Client::MmapedValue.reset_and_reinitialize
      end

      def reinitialize_on_pid_change
        ::Prometheus::Client::MmapedValue.reinitialize_on_pid_change
      end
    end
  end
end
