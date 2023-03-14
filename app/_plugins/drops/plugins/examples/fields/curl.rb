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
          end
        end
      end
    end
  end
end
