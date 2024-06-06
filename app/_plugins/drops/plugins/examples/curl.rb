# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Curl < Base
          URLS = {
            'consumer' => 'http://localhost:8001/consumers/{consumerName|Id}/plugins',
            'consumer_group' => 'http://localhost:8001/consumer_groups/{consumerGroupName|Id}/plugins',
            'global' => 'http://localhost:8001/plugins/',
            'route' => 'http://localhost:8001/routes/{routeName|Id}/plugins',
            'service' => 'http://localhost:8001/services/{serviceName|Id}/plugins'
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
