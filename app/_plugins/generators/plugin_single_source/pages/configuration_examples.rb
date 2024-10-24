# frozen_string_literal: true

require_relative 'how_to'

module PluginSingleSource
  module Pages
    class ConfigurationExamples < HowTo
      def canonical_url
        "#{base_url}how-to/basic-example/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{gateway_release}/how-to/basic-example/"
        end
      end

      def page_title
        @page_title ||= I18n.t('hub.page_title.basic_config_examples', locale: translate_to,
                                                                       plugin_name: @release.metadata['name'])
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/how-to/basic-example/"
      end

      def content
        ''
      end

      def nav_title
        @nav_title ||= I18n.t('hub.sidebar.basic_config_examples', locale: translate_to)
      end

      def breadcrumb_title
        @breadcrumb_title ||= I18n.t('hub.breadcrumbs.basic_config_examples', locale: translate_to)
      end

      def icon
        ''
      end

      def edit_link
        if @release.vendor == 'kong-inc'
          name = @release.name
          "https://github.com/Kong/docs-plugin-toolkit/edit/main/examples/#{name}/_#{@release.version}.yaml"
        else
          "https://github.com/Kong/docs.konghq.com/edit/#{@site.config['git_branch']}/app/_hub/#{@release.vendor}/#{@release.name}/examples/_index.yml"
        end
      end

      private

      def ssg_hub
        false
      end

      def layout
        'plugins/configuration_examples'
      end
    end
  end
end
