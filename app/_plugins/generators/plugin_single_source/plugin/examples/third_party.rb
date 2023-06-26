# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Examples
      class ThirdParty < Base
        EXAMPLES_PATH = 'app/_hub'

        def file_path
          File.join(EXAMPLES_PATH, @vendor, @name, 'examples/_index.yml')
        end
      end
    end
  end
end
