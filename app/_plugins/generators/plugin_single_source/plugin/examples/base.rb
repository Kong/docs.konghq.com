# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Examples
      class Base
        def self.make_for(vendor:, name:, version:)
          if vendor == 'kong-inc'
            Kong.new(vendor:, name:, version:)
          else
            ThirdParty.new(vendor:, name:, version:)
          end
        end

        def initialize(vendor:, name:, version:)
          @vendor = vendor
          @name = name
          @version = version
        end

        def example
          @example ||= YAML.load(File.read(file_path)) if File.exist?(file_path)
        end
      end
    end
  end
end
