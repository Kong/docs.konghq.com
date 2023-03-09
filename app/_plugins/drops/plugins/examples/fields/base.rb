# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module Fields
          class Base
            def self.make_for(key:, values:)
              case values
              when Array
                values.map { |v| make_for(key:, values: v) }
              when Hash
                values.map { |k, v| make_for(key: "#{key}.#{k}", values: v) }
              else
                new(key:, values:)
              end
            end

            def initialize(key:, values:)
              @key = key
              @values = values
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
