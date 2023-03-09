# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Base < Liquid::Drop
          def initialize(example:, type:, config:) # rubocop:disable Lint/MissingSuper
            @example = example
            @type = type
            @config = config
          end

          def plugin_name
            @plugin_name ||= @example.fetch('name')
          end
        end
      end
    end
  end
end
