# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module Fields
          class Base < Liquid::Drop
            def self.make_for(key:, values:, options: {})
              case values
              when Array
                values.map { |v| make_for(key:, values: v, options:) }.flatten
              when Hash
                values.map { |k, v| make_for(key: "#{key}.#{k}", values: v, options:) }.flatten
              else
                new(key:, values:, options:)
              end
            end

            attr_reader :key, :values

            def initialize(key:, values:, options: {}) # rubocop:disable Lint/MissingSuper
              @key = key
              @values = values
              @options = options
            end

            def to_s
              "#{@key}=#{@values}"
            end
          end
        end
      end
    end
  end
end
