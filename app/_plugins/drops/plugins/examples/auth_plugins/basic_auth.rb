# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module AuthPlugins
          class BasicAuth < Base
            def self.fields
              {
                'username' => 'alex',
                'password' => 'secret123'
              }
            end

            def self.next_steps_url
              '/#using-the-credential'
            end
          end
        end
      end
    end
  end
end
