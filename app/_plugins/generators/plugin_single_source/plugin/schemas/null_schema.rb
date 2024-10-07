# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    module Schemas
      class NullSchema < Base
        def schema
          {}
        end
      end
    end
  end
end
