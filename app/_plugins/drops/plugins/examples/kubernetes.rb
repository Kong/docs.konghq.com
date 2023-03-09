# frozen_string_literal: true

require_relative './yaml'

module Jekyll
  module Drops
    module Plugins
      module Examples
        class Kubernetes < Yaml
          def default_config
            ['<optional_parameter>: <value>']
          end
        end
      end
    end
  end
end
