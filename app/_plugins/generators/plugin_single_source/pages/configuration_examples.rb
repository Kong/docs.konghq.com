# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class ConfigurationExamples < Base
      TITLE = 'Examples'

      def canonical_url
        "#{base_url}configuration/examples/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/configuration/examples/"
        end
      end

      def page_title
        "#{@release.metadata['name']} Configuration #{TITLE}"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/configuration/examples"
      end

      def source_file; end

      def content
        ''
      end

      def nav_title
        TITLE
      end

      def breadcrumb_title
        "Configuration #{TITLE}"
      end

      def icon
        ''
      end

      def edit_link
        if @release.vendor == 'kong-inc'
          name = @release.name == 'serverless-functions' ? 'pre-function' : @release.name
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
