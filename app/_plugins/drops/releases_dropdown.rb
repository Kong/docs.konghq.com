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
        if @release.latest?
          "/#{@page.data['edition']}/latest/"
        else
          "/#{@page.data['edition']}/#{@release}/"
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
        "#{@page.data['edition']}-#{@page.data['release']}"
      end
    end
  end
end
