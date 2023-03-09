# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module Fields
          class KongManager < Base
            def to_s
              # raise "Invalid value for required field #{@key}" if @values.nil?
              p "Invalid value for required field #{@key}" if @values.nil?

              if [true, false].include?(@values)
                "config.#{@key}: #{boolean_value}"
              elsif @values.is_a?(String)
                "config.#{@key}: `#{@values.gsub("'", '')}`"
              else
                "config.#{@key}: `#{@values}`"
              end
            end

            private

            def boolean_value
              @values ? 'select checkbox' : 'clear checkbox'
            end
          end
        end
      end
    end
  end
end
