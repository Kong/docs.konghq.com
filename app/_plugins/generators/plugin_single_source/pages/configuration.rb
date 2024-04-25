# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Configuration < Base
      TITLE = 'Configuration'

      def canonical_url
        "#{base_url}configuration/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{gateway_release}/configuration/"
        end
      end

      def page_title
        "#{@release.metadata['name']} #{TITLE}"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/configuration/"
      end

      def content
        ''
      end

      def nav_title
        'Configuration reference'
      end

      def breadcrumb_title
        TITLE
      end

      def icon; end

      def edit_link
        if @release.vendor == 'kong-inc'
          kong_edit_link
        elsif @release.schema
          "https://github.com/Kong/docs.konghq.com/edit/#{@site.config['git_branch']}/app/#{source_file}"
        end
      end

      def kong_edit_link
        return @release.metadata['schema_source_url'] if @release.metadata.key?('schema_source_url')

        if @release.enterprise_plugin?
          "https://github.com/Kong/kong-ee/edit/master/plugins-ee/#{@release.name}/kong/plugins/#{@release.name}/schema.lua"
        elsif @release.name == 'pre-function' || @release.name == 'post-function'
          'https://github.com/Kong/kong/edit/master/kong/plugins/pre-function/_schema.lua'
        else
          "https://github.com/Kong/kong/edit/master/kong/plugins/#{@release.name}/schema.lua"
        end
      end

      private

      def ssg_hub
        false
      end

      def layout
        'plugins/configuration'
      end
    end
  end
end
