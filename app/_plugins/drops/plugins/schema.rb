# frozen_string_literal: true

require 'forwardable'

module Jekyll
  module Drops
    module Plugins
      class SchemaField < Liquid::Drop
        attr_reader :name, :schema

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
          @schema['referenceable'] || @schema.dig('elements', 'referenceable')
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

        def deprecated?
          !!@schema['deprecation']
        end

        def deprecation
          @deprecation ||= @schema['deprecation']
        end

        def elements # rubocop:disable Metrics/AbcSize
          return {} unless @schema.key?('elements')

          @elements ||= begin
            @schema['elements']['fields'] = @schema['elements'].fetch('fields', []).map do |f|
              next if f.values.first.key?('deprecation')

              SchemaField.new(name: f.keys.first, parent: anchor, schema: f.values.first)
            end
            @schema['elements']
          end.compact
        end

        def fields
          @fields ||= @schema.fetch('fields', []).map do |f|
            next if f.values.first.key?('deprecation')

            SchemaField.new(name: f.keys.first, parent: anchor, schema: f.values.first)
          end.compact
        end
      end

      class Schema < Liquid::Drop
        extend Forwardable

        def_delegators :@schema, :enable_on_consumer?, :enable_on_route?,
                       :enable_on_service?, :enable_on_consumer_group?

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

        def protocols
          @protocols ||= SchemaField.new(name: 'protocols', parent: '', schema: @schema.protocols_field)
        end

        def fields
          return [] if @schema.config.empty?

          [SchemaField.new(name: 'config', parent: '', schema: @schema.config)]
        end

        def deprecated_fields
          return [] if @schema.config.empty?

          @deprecated_fields ||= shorthand_fields.concat(fields_flagged_as_deprecated).flatten.compact
        end

        def defined?
          !@schema.config.empty?
        end

        private

        def shorthand_fields
          @shorthand_fields ||= @schema.config.fetch('shorthand_fields', []).map do |f|
            SchemaField.new(name: f.keys.first, parent: f.keys.first, schema: f.values.first)
          end
        end

        def fields_flagged_as_deprecated
          @fields_flagged_as_deprecated ||= @schema.deprecated_fields.map do |f|
            SchemaField.new(name: f[:name], parent: f[:parent], schema: f[:schema])
          end
        end
      end
    end
  end
end
