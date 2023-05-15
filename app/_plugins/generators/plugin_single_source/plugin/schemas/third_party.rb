# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Schemas
      class ThirdParty < Base
        SCHEMAS_PATH = 'app/_hub'

        def file_path
          @file_path ||= File.join(
            SCHEMAS_PATH,
            vendor,
            plugin_name,
            'schemas/_index.json'
          )
        end
      end
    end
  end
end
