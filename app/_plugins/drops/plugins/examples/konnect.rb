# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Konnect < Base
          URLS = {
            'consumer' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{CONTROL-PLANE-ID}/core-entities/consumers/{CONSUMER_ID}/plugins',
            'consumer_group' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{CONTROL-PLANE-ID}/core-entities/consumer_groups/{CONSUMER_GROUP_ID}/plugins',
            'global' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{CONTROL-PLANE-ID}/core-entities/plugins/',
            'route' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{CONTROL-PLANE-ID}/core-entities/routes/{ROUTE_ID}/plugins',
            'service' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{CONTROL-PLANE-ID}/core-entities/services/{SERVICE_ID}/plugins'
          }.freeze

          def params
            @params ||= { 'name' => plugin_name }.merge(config_to_params)
          end

          def url
            @url ||= URLS.fetch(@type)
          end

          private

          def config_to_params
            return {} unless @example.key?('config')

            { 'config' => @example.fetch('config') }
          end
        end
      end
    end
  end
end
