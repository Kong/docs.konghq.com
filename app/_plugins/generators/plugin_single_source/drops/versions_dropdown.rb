# frozen_string_literal: true

module PluginSingleSource
  module Drops
    class VersionsDropdownOption < Liquid::Drop
      def initialize(page:, version:, latest:, current:) # rubocop:disable Lint/MissingSuper
        @page = page
        @version = version
        @latest = latest
        @current = current
      end

      def url
        @url ||= begin
          version = @version == @latest ? '' : @version
          @page.dropdown_url.gsub('VERSION', version).gsub('//', '/')
        end
      end

      def css_class
        @current == @version ? 'active' : ''
      end

      def text
        if @version == @latest
          "#{@version} <em>(latest)</em>"
        else
          @version
        end
      end
    end

    class VersionsDropdown < Liquid::Drop
      def initialize(page) # rubocop:disable Lint/MissingSuper
        @page = page
      end

      def versions
        @versions ||= extn_releases.map do |version|
          VersionsDropdownOption.new(page: @page, version:, latest:, current:)
        end
      end

      def extn_releases
        @extn_releases ||= @page.release.ext_data['releases']
      end

      def current
        @current ||= @page.version
      end

      def latest
        @latest ||= extn_releases.first
      end
    end
  end
end
