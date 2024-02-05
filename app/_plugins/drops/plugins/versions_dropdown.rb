# frozen_string_literal: true

module Jekyll
  module Drops
    module Plugins
      class VersionsDropdownOption < Liquid::Drop
        def initialize(page:, release:, latest:, current:) # rubocop:disable Lint/MissingSuper
          @page = page
          @release = release
          @latest = latest
          @current = current
        end

        def url
          @url ||= begin
            release = @latest && @latest == @release ? '' : @release
            @page.dropdown_url.gsub('VERSION', release).gsub('//', '/')
          end
        end

        def css_class
          @current == @release ? 'active' : ''
        end

        def text
          if @release == @latest
            "#{@release} <em>(latest)</em>"
          else
            @release
          end
        end
      end

      class VersionsDropdown < Liquid::Drop
        def initialize(page) # rubocop:disable Lint/MissingSuper
          @page = page
        end

        def versions
          @versions ||= extn_releases.map do |r|
            VersionsDropdownOption.new(page: @page, release: release(r), latest:, current:)
          end
        end

        def extn_releases
          @extn_releases ||= @page.release.ext_data['releases']
        end

        def current
          @current ||= gateway_releases
                       .detect { |r| r.value == @page.gateway_release || r.label == @page.gateway_release }
                       .to_liquid
        end

        def latest
          @latest ||= @page.data['extn_latest']
        end

        private

        def release(release)
          gateway_releases
            .detect { |r| r.value == release || r.label == release }
            .to_liquid
        end

        def gateway_releases
          @gateway_releases ||= @page.site.data.dig('editions', 'gateway')
                                     .releases
                                     .select { |r| extn_releases.include?(r.value) }
        end
      end
    end
  end
end
