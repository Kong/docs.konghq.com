# frozen_string_literal: true

module SEO
  module Tags
    module Version
      class OAS < Base
        def version
          version = if Gem::Version.correct?(version_name)
                      ::Utils::Version.to_release(version_name)
                    else
                      version_name
                    end

          "v#{version}"
        end

        def version_name
          @version_name ||= @page.data.dig('version', 'name')
        end
      end
    end
  end
end
