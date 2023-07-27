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
          !!@metadata['konnect']
        end

        def enterprise?
          !!@metadata['enterprise'] && !!!@metadata['free']
        end

        def techpartner?
          !!@metadata['techpartner'] && @publisher != KONG_INC
        end

        def hash
          "publisher:#{@publisher}-" \
            "plus:#{plus?}-" \
            "konnect:#{konnect?}-" \
            "enterprise:#{enterprise?}-" \
            "techpartner:#{techpartner?}"
        end
      end
    end
  end
end
