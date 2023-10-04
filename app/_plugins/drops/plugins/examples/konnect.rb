# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Konnect < Base
          URLS = {
            'consumer' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/consumers/{consumerId}/plugins',
            'consumer_group' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/consumer_groups/{consumerGroupId}/plugins',
            'global' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/plugins/',
            'route' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/routes/{routeId}/plugins',
            'service' => 'https://{us|eu}.api.konghq.com/v2/control-planes/{controlPlaneId}/core-entities/services/{serviceId}/plugins'
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
