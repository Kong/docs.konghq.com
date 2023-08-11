# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module AuthPlugins
          class JwtAuth < Base
            def self.fields
              {
                'algorithm' => 'HS256',
                'secret' => 'this_is_a_super_secret_value'
              }
            end

            def self.next_steps_url
              '/#craft-a-jwt-with-a-secret-hs256'
            end
          end
        end
      end
    end
  end
end
