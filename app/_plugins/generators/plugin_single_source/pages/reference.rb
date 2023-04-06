# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Reference < Base
      def canonical_url
        "#{base_url}reference/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/reference.html"
        end
      end

      def page_title
        "#{@release.frontmatter['name']} plugin reference"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/reference/"
      end

      def source_file; end

      def content
        ''
      end

      def nav_title
        'Configuration Reference'
      end

      private

      def ssg_hub
        false
      end

      def layout
        'plugins/configuration-reference'
      end
    end
  end
end
