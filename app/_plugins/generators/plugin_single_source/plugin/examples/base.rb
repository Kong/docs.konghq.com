# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Examples
      class Base
        HUB_PATH = 'app/_hub'

        def self.make_for(vendor:, name:, version:, example_name: nil)
          if vendor == 'kong-inc'
            Kong.new(vendor:, name:, version:, example_name:)
          else
            ThirdParty.new(vendor:, name:, version:, example_name:)
          end
        end

        def initialize(vendor:, name:, version:, example_name: nil)
          @vendor = vendor
          @name = name
          @version = version
          @example_name = example_name
        end

        def example
          @example ||= YAML.load_file(file_path) if File.exist?(file_path)
        end
      end
    end
  end
end
