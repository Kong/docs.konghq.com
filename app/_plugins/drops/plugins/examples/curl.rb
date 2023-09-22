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
            @params ||= [
              Fields::Curl.new(key: 'name', values: plugin_name),
              config_to_params
            ].flatten
          end

          def url
            @url ||= URLS.fetch(@type)
          end

          private

          def config_to_params
            @example.fetch('config', []).map do |field, values|
              Fields::Curl.make_for(
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
