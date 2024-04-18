# frozen_string_literal: true

module SEO
  module Tags
    module Version
      class Base
        def self.make_for(page)
          if no_version?(page)
            NoVersion.new(page)
          elsif page.data['layout'] == 'oas/spec'
            OAS.new(page)
          else
            new(page)
          end
        end

        def self.no_version?(page)
          page.data['is_latest'] ||
            page.data['no_version'] ||
            (page.data['layout'] != 'oas/spec' && !page.data['release'])
        end

        def initialize(page)
          @page = page
        end

        def version
          if @page.data['release']&.label
            @page.data['release']
          else
            "v#{@page.data['release']}"
          end
        end
      end
    end
  end
end
