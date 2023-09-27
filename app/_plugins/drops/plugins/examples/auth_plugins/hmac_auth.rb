# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module AuthPlugins
          class HmacAuth < Base
            def self.fields
              {
                'username' => 'alex',
                'secret' => 'secret123'
              }
            end

            def self.next_steps_url
              '/#signature-authentication-scheme'
            end
          end
        end
      end
    end
  end
end
