# frozen_string_literal: true

module Jekyll
  module Drops
    module Oas
      class Version < Liquid::Drop
        attr_reader :version

        def initialize(base_url:, version:) # rubocop:disable Lint/MissingSuper
          @base_url = base_url
          @version  = version
        end

        def label
          @label ||= name
        end

        def value
          @value ||= "#{@base_url}#{name}/"
        end

        def id
          @id ||= @version['id']
        end

        def as_json
          { 'value' => value, 'label' => label, 'id' => id }
        end

        def name
          @name ||= @version['name']
        end
      end
    end
  end
end
