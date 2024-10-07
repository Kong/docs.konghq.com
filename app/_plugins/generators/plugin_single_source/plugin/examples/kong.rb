# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Examples
      class Kong < Base
        EXAMPLES_PATH = 'app/_src/.repos/kong-plugins/examples'

        def file_path
          @file_path ||= if @example_name
                           path = File.join(HUB_PATH, @vendor, @name, 'examples', @example_name)
                           Utils::SingleSourceFileFinder.find(file_path: path, version: @version)
                         else
                           File.join(EXAMPLES_PATH, plugin_folder, "_#{release_version}.yaml")
                         end
        end

        def release_version
          @version.split('.').first(2).join('.').concat('.x')
        end

        private

        def plugin_folder
          @name
        end
      end
    end
  end
end
