# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class References < Base
      def canonical_url
        "#{base_url}api/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{gateway_release}/api/"
        end
      end

      def page_title
        @page_title ||= I18n.t('hub.page_title.api_reference', locale: translate_to,
                                                               plugin_name: @release.metadata['name'])
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/api/"
      end

      def nav_title
        @nav_title ||= ::Utils::FrontmatterParser
                       .new(File.read(File.expand_path(@file, @source_path)))
                       .frontmatter.fetch('nav_title', 'Missing nav_title')
      end

      def icon
        '/assets/images/icons/hub-layout/icn-reference.svg'
      end

      def breadcrumb_title
        @breadcrumb_title ||= I18n.t('hub.breadcrumbs.api_reference', locale: translate_to,
                                                                      plugin_name: @release.metadata['name'])
      end

      private

      def ssg_hub
        false
      end
    end
  end
end
