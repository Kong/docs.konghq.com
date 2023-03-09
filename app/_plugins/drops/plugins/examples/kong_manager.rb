# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class KongManager < Base
          def fields
            @fields ||= required_fields.map do |f|
              Fields::KongManager.make_for(
                key: f['name'],
                values: value_from_example(f)
              )
            end.flatten.map(&:to_s)
          end

          private

          # TODO: Handle min/max versions? Or use the schemas directly?
          def required_fields
            @required_fields ||= @config.fetch('config', []).select do |f|
              f['required'] == true && !f['value_in_examples'].nil? # f['default'].nil?
            end
          end

          # TODO: fetch value from example, if not, fetch it from the config for now
          def value_from_example(field)
            @example.fetch('config', {})[field['name']] ||
              @config['config'].detect { |f| f['name'] == field['name'] }['value_in_examples']
          end
        end
      end
    end
  end
end
