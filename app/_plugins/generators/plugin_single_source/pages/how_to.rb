# frozen_string_literal: true

require_relative 'nestable'

module PluginSingleSource
  module Pages
    class HowTo < Base
      include ::PluginSingleSource::Pages::Nestable

      def page_title
        "Using the #{@release.metadata['name']} plugin"
      end

      def breadcrumb_title
        page_title
      end

      def breadcrumbs
        [
          { text: category_title, url: category_url },
          { text: @release.metadata['name'], url: base_section_url },
          { text: 'How to', url: how_to_url },
          { text: breadcrumb_title, url: permalink }
        ]
      end

      private

      def how_to_url
        return unless index_file_exist?

        base_section_url.concat('how-to/')
      end

      def ssg_hub
        false
      end

      def index_file_exist?
        File.exist?(File.expand_path('how-to/_index.md', @source_path))
      end
    end
  end
end
