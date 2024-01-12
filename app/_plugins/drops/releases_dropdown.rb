# frozen_string_literal: true

module Jekyll
  module Drops
    class Option < Liquid::Drop
      def initialize(release:, page:) # rubocop:disable Lint/MissingSuper
        @release = release
        @page = page
      end

      def value
        return label unless @release.latest?

        "#{label} <em>(latest)</em>"
      end

      def active?
        @page.data['release'] == @release
      end

      def url
        if page_exists?(version_page_url)
          version_page_url
        else
          root_url
        end
      end

      def data_id
        @data_id ||= @release.value
      end

      private

      def label
        @label ||= if @release.label
                     "<em>#{@release.label}</em>"
                   else
                     @release
                   end
      end

      def page_exists?(url)
        !@page.site.pages.detect { |p| p.url == url }.nil?
      end

      def root_url
        "/#{@page.data['edition']}/#{@release}/"
      end

      def version_page_url
        version_url = @page
                      .url
                      .gsub(@page.data['release'], @release)
                      .gsub('/latest/', "/#{@release}/")

        version_url << "/#{@release}/" unless version_url.include?(@release.to_s)

        version_url
      end
    end

    class ReleasesDropdown < Liquid::Drop
      def initialize(page) # rubocop:disable Lint/MissingSuper
        @page = page
      end

      def current
        @current ||= @page.data['release']
      end

      def options
        @options ||= @page.data['releases'].map do |r|
          Option.new(release: r, page: @page)
        end
      end

      def hash
        @hash ||= "#{@page.data['edition']}-#{@page.data['release']}-#{@page.url}".hash
      end
    end
  end
end
