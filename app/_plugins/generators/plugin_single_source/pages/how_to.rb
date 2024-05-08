# frozen_string_literal: true

require_relative 'nestable'

module PluginSingleSource
  module Pages
    class HowTo < Base
      include ::PluginSingleSource::Pages::Nestable

      def page_title
        @page_title ||= I18n.t('hub.page_title.how_to', locale: translate_to, plugin_name: @release.metadata['name'])
      end

      def breadcrumb_title
        page_title
      end

      def breadcrumbs
        [
          { text: category_title, url: category_url },
          { text: @release.metadata['name'], url: base_section_url },
          { text: 'How to', url: how_to_url },
          { text: nav_title, url: permalink }
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
        File.exist?(File.expand_path('how-to/_index.md', @release.pages_source_path))
      end

      def base_section_url
        base_path = permalink.split('/').tap(&:pop)
        if @release.latest?
          base_path.take(4)
        else
          base_path.take(5) # include version
        end.join('/').concat('/')
      end
    end
  end
end
