# frozen_string_literal: true

require 'forwardable'

module Jekyll
  module Drops
    module Plugins
      class SchemaField < Liquid::Drop
        attr_reader :name

        def initialize(name:, parent:, schema:) # rubocop:disable Lint/MissingSuper
          @name = name
          @parent = parent
          @schema = schema
        end

        def anchor
          return @name if @parent.empty?

          "#{@parent}-#{@name}"
        end

        def required
          @schema['required']
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

        def description
          @schema['description']
        end

        def between
          @schema['between']
        end

        def len_min
          @schema['len_min']
        end

        def len_max
          @schema['len_max']
        end

        def match
          @schema['match']
        end

        def starts_with
          @schema['starts_with']
        end

        def one_of
          @schema['one_of']
        end

        def elements
          return {} unless @schema.key?('elements')

          @elements ||= begin
            @schema['elements']['fields'] = @schema['elements'].fetch('fields', []).map do |f|
              SchemaField.new(name: f.keys.first, parent: anchor, schema: f.values.first)
            end
            @schema['elements']
          end
        end

        def fields
          @fields ||= all_fields.map do |f|
            SchemaField.new(name: f.keys.first, parent: anchor, schema: f.values.first)
          end
        end

        private

        def all_fields
          @all_fields ||= @schema.fetch('fields', [])
                                 .concat(@schema.fetch('shorthand_fields', []))
        end
      end

      class Schema < Liquid::Drop
        extend Forwardable

        def_delegators :@schema, :enable_on_consumer?, :enable_on_route?,
                       :enable_on_service?

        def initialize(schema:, metadata:) # rubocop:disable Lint/MissingSuper
          @schema = schema
          @metadata = metadata
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
          @fields ||= [
            SchemaField.new(name: 'config', parent: '', schema: @schema.config)
          ]
        end
      end
    end
  end
end
