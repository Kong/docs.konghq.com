# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Konnect < Base
          URLS = {
            'consumer' => 'https://{us|eu}.api.konghq.com/v2/{RUNTIME-GROUP-ID}/core-entities/consumers/{CONSUMER_ID}/plugins',
            'consumer_group' => 'https://{us|eu}.api.konghq.com/v2/{RUNTIME-GROUP-ID}/core-entities/consumer_groups/{CONSUMER_GROUP_ID}/plugins',
            'global' => 'https://{us|eu}.api.konghq.com/v2/{RUNTIME-GROUP-ID}/core-entities/plugins/',
            'route' => 'https://{us|eu}.api.konghq.com/v2/{RUNTIME-GROUP-ID}/core-entities/routes/{ROUTE_ID}/plugins',
            'service' => 'https://{us|eu}.api.konghq.com/v2/{RUNTIME-GROUP-ID}/core-entities/services/{SERVICE_ID}/plugins'
          }.freeze

          def params
            @params ||= [
              Fields::Konnect.new(key: 'name', values: plugin_name),
              config_to_params
            ].flatten
          end

          def url
            @url ||= URLS.fetch(@type)
          end

          private

          def config_to_params
            @example.fetch('config', []).map do |field, values|
              Fields::Konnect.make_for(
                key: "config.#{field}",
                values:,
                options: field_config(field)
              )
            end
          end

          def field_config(_field)
            # TODO: handle url-encode with overlays or metadata
            {}
            # @config.fetch('config', {}).detect { |f| f['name'] == field } || {}
          end
        end
      end
    end
  end
end
