# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Overview < Base
      def content
        @content ||= <<~CONTENT
          #{how_to}

          #{reference}

          #{changelog}
        CONTENT
      end

      def how_to
        @how_to ||= Pages::HowTo.new(
          release: @release,
          file: 'how-to/_index.md',
          source_path: @release.pages_source_path
        ).content
      end

      def reference
        @reference ||= Pages::Reference.new(
          release: @release,
          file: 'reference/_index.md',
          source_path: @release.pages_source_path
        ).content
      end

      def changelog
        @changelog ||= Pages::Changelog.new(
          release: @release,
          file: '_changelog.md',
          source_path: @release.plugin_base_path
        ).content
      end

      def canonical_url
        base_url
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}.html"
        end
      end

      def page_title
        "#{@release.frontmatter['name']} Overview"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/"
      end

      private

      def ssg_hub
        @release.latest?
      end

      def page_attributes
        super.merge('layout' => 'extension')
      end
    end
  end
end
