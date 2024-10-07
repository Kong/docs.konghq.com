# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module AuthPlugins
          class KeyAuth < Base
            def self.fields
              {
                'key' => 'hello_world'
              }
            end

            def self.next_steps_url
              '/#make-a-request-with-the-key'
            end
          end
        end
      end
    end
  end
end
