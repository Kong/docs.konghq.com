# frozen_string_literal: true

require 'yaml'

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Yaml < Base
          FIELD = {
            'consumer' => 'consumer: CONSUMER_NAME|CONSUMER_ID',
            'global' => nil,
            'route' => 'route: ROUTE_NAME',
            'service' => 'service: SERVICE_NAME|SERVICE_ID'
          }.freeze

          def example_config
            @example_config ||= if @example['config']
                                  YAML.dump(@example['config']).gsub("---\n", '').lines.map do |l|
                                    l.gsub("\n", '')
                                  end
                                else
                                  default_config
                                end
          end

          def type_field
            @type_field ||= FIELD.fetch(@type)
          end

          def default_config
            ['EXAMPLE_PARAMETER: EXAMPLE_VALUE']
          end
        end
      end
    end
  end
end
