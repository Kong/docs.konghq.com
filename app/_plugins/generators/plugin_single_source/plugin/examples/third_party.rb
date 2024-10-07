# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Examples
      class ThirdParty < Base
        def file_path
          base_path = File.join(HUB_PATH, @vendor, @name, 'examples')

          if @example_name
            Utils::SingleSourceFileFinder.find(
              file_path: File.join(base_path, @example_name),
              version: @version
            )
          else
            File.join(base_path, '_index.yml')
          end
        end
      end
    end
  end
end
