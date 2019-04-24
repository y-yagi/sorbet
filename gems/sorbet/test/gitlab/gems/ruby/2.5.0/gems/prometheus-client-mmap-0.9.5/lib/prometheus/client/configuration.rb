require 'prometheus/client/registry'
require 'prometheus/client/mmaped_value'
require 'logger'
require 'tmpdir'

module Prometheus
  module Client
    class Configuration
      attr_accessor :value_class, :multiprocess_files_dir, :initial_mmap_file_size, :logger, :pid_provider

      def initialize
        @value_class = ::Prometheus::Client::MmapedValue
        @initial_mmap_file_size = 4 * 1024
        @logger = Logger.new($stdout)
        @pid_provider = Process.method(:pid)
        @multiprocess_files_dir = ENV.fetch('prometheus_multiproc_dir') do
          Dir.mktmpdir("prometheus-mmap").tap do |tmp|
            @logger.warn("Please set prometheus_multiproc_dir to persistent directory path. Temporarily writing mmap files to #{tmp}")
          end
        end
      end
    end
  end
end
