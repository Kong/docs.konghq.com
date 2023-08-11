# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        module AuthPlugins
          class Base < Liquid::Drop
            def self.make_for(plugin_name)
              auth = {
                'key-auth' => KeyAuth,
                'basic-auth' => BasicAuth,
                'hmac-auth' => HmacAuth,
                'jwt' => JwtAuth
              }[plugin_name]

              raise "Invalid plugin name #{plugin_name}" unless auth

              auth
            end
          end
        end
      end
    end
  end
end
