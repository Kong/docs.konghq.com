# frozen_string_literal: true

require 'yaml'

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Yaml < Base
          FIELD = {
            'consumer' => 'consumer: CONSUMER_NAME|ID',
            'consumer_group' => 'consumer_group: CONSUMER_GROUP_NAME|ID',
            'global' => nil,
            'route' => 'route: ROUTE_NAME|ID',
            'service' => 'service: SERVICE_NAME|ID'
          }.freeze

          def example_config
            @example_config ||= if @example['config']
                                  YAML.dump(@example['config']).delete_prefix("---\n").lines.map do |l|
                                    l.gsub("\n", '')
                                  end
                                end
          end

          def type_field
            @type_field ||= FIELD.fetch(@type)
          end
        end
      end
    end
  end
end
