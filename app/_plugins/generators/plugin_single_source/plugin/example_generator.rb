# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class ExampleGenerator
      def initialize(schema:)
        @schema = schema
        @config = Hash.new { |h, k| h[k] = Hash.new(&h.default_proc) }
      end

      def generate
        return { 'name' => @schema.plugin_name }.merge(@config)

        extract_examples_from_schema(config_field, @config)

        { 'name' => @schema.plugin_name }.merge(@config)
      end

      private

      def extract_examples_from_schema(field, example) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
        field_name = field.keys.first

        example[field_name] = field[field_name]['examples'].first if field[field_name].key?('examples')
        if field[field_name].key?('fields')
          field[field_name]['fields'].each do |f|
            extract_examples_from_schema(f, example[field_name])
          end
          example.delete(field_name) if example[field_name].nil? || example[field_name].empty?
        end
        if field.dig(field_name, 'elements', 'fields') # rubocop:disable Style/GuardClause
          field[field_name]['elements']['fields'].each do |f|
            extract_examples_from_schema(f, example[field_name])
          end

          example.delete(field_name) if example[field_name].nil? || example[field_name].empty?
        end
      end

      def config_field
        @config_field ||= @schema.fields.detect { |f| f.key?('config') }
      end
    end
  end
end
