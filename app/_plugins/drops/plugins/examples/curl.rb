# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Curl < Base
          URLS = {
            'consumer' => 'http://localhost:8001/consumers/CONSUMER_NAME|CONSUMER_ID/plugins',
            'global' => 'http://localhost:8001/plugins/',
            'route' => 'http://localhost:8001/routes/ROUTE_NAME|ROUTE_ID/plugins',
            'service' => 'http://localhost:8001/services/SERVICE_NAME|SERVICE_ID/plugins'
          }.freeze

          # XXX: handle url_encode somehow...
          def params
            @params ||= ["name=#{plugin_name}", config_to_params].flatten.map(&:to_s)
          end

          def url
            @url ||= URLS.fetch(@type)
          end

          private

          def config_to_params
            @example.fetch('config', []).map do |field, values|
              Fields::Base.make_for(key: "config.#{field}", values:)
            end
          end
        end
      end
    end
  end
end
