# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      class Badges < Liquid::Drop
        KONG_INC = 'kong-inc'

        def initialize(metadata:, publisher:) # rubocop:disable Lint/MissingSuper
          @metadata = metadata
          @publisher = publisher
        end

        def plus?
          !@metadata['free'] && !!@metadata['plus'] && @publisher == KONG_INC
        end

        def konnect?
          @publisher == KONG_INC && !!@metadata['konnect']
        end

        def enterprise?
          !!@metadata['enterprise'] && !!!@metadata['free']
        end

        def hash
          "publisher:#{@publisher}-plus:#{plus?}-konnect:#{konnect?}-enterprise:#{enterprise?}"
        end
      end
    end
  end
end
