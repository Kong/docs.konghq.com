# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Changelog < Base
      def canonical_url
        "#{base_url}changelog/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{gateway_release}/changelog/"
        end
      end

      def page_title
        @page_title ||= I18n.t('hub.page_title.changelog', locale: translate_to, plugin_name: @release.metadata['name'])
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/changelog/"
      end

      def nav_title
        @nav_title ||= I18n.t('hub.sidebar.changelog', locale: translate_to)
      end

      def breadcrumb_title
        @breadcrumb_title ||= I18n.t('hub.breadcrumbs.changelog', locale: translate_to)
      end

      def icon
        '/assets/images/icons/hub-layout/icn-changelog.svg'
      end

      private

      def ssg_hub
        false
      end
    end
  end
end
