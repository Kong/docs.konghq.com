# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      module Examples
        class KongManager < Base
          def fields
            # TODO: decide which fields/values to use
            []
            # @fields ||= required_fields.map do |f|
            #   Fields::KongManager.make_for(
            #     key: f['name'],
            #     values: value_from_example(f)
            #   )
            # end.flatten.map(&:to_s)
          end
        end
      end
    end
  end
end
