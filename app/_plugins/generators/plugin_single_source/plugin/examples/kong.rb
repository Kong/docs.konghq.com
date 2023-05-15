# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Examples
      class Kong < Base
        EXAMPLES_PATH = 'app/_src/.repos/kong-plugins/examples'

        def file_path
          @file_path ||= File.join(EXAMPLES_PATH, @name, "_#{release_version}.yaml")
        end

        def release_version
          @version.split('.').first(2).join('.').concat('.x')
        end
      end
    end
  end
end
