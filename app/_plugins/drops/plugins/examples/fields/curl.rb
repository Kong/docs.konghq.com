# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module Fields
          class Curl < Base
            def curl_options
              return unless @options['urlencode_in_examples']

              ['-urlencode']
            end

            def to_s
              "#{@key}=#{escaped_values}"
            end

            def escaped_values
              if @values.is_a?(String)
                @values.gsub('"', '\"')
              else
                @values
              end
            end
          end
        end
      end
    end
  end
end
