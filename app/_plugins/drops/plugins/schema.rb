# frozen_string_literal: true

require 'forwardable'

module Jekyll
  module Drops
    module Plugins
      class SchemaField < Liquid::Drop
        attr_reader :name

        def initialize(name:, schema:, metadata:) # rubocop:disable Lint/MissingSuper
          @name = name
          @schema = schema
          @metadata = metadata || {} # field might not be defined in the config file
        end

        def required
          if @metadata.key?('required') && @metadata.fetch('required') == 'semi'
            'semi'
          else
            @schema['required']
          end
        end

        def group
          @metadata['group']
        end

        def description
          @schema['description'] || @metadata['description']
        end

        def type
          @schema['type']
        end

        def default
          @schema['default']
        end

        def encrypted
          @schema['encrypted']
        end

        def referenceable
          @schema['referenceable']
        end
      end

      class Schema < Liquid::Drop
        extend Forwardable

        def_delegators :@schema, :enable_on_consumer?, :enable_on_route?,
                       :enable_on_service?

        def initialize(schema:, metadata:, version:) # rubocop:disable Lint/MissingSuper
          @schema = schema
          @metadata = metadata
          @version = version

          fields
        end

        def global?
          # false only for application-registration
          return true unless @metadata.key?('global')

          @metadata['global']
        end

        def api_id
          @api_id ||= @metadata['api_id']
        end

        def fields
          @fields ||= @schema.config.fetch('fields', []).map do |f|
            build_field(f)
          end
        end

        private

        def build_field(field)
          name = field.keys.first
          SchemaField.new(
            name:,
            schema: field.values.first,
            metadata: @metadata.fetch('config', []).detect { |f| f['name'] == name }
          )
        end
      end
    end
  end
end
