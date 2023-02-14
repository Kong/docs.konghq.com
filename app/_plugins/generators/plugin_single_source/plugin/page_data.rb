# frozen_string_literal: true

module PluginSingleSource
  module Plugin
    class PageData
      def self.generate(release:)
        new(release:).build_data
      end

      def initialize(release:)
        @release = release
        @data = {}
      end

      def build_data
        @data
          .merge!(@release.frontmatter)
          .merge!(configuration)
          .merge!(page_attributes)
          .merge!(frontmatter_overrides)

        @data
      end

      def page_attributes
        {
          'is_latest' => @release.latest?,
          'seo_noindex' => @release.latest? ? nil : true,
          'version' => @release.set_version? ? @release.version : nil,
          'extn_slug' => @release.name,
          'extn_publisher' => @release.vendor,
          'extn_release' => @release.version,
          'extn_icon' => extn_icon,
          'layout' => layout
        }
      end

      private

      def extn_icon
        @extn_icon ||= @data.fetch(
          'header_icon',
          "/assets/images/icons/hub/#{@release.vendor}_#{@release.name}.png"
        )
      end

      def layout
        # Set the layout if it's not already provided
        @layout ||= @data.fetch('layout', 'extension')
      end

      def frontmatter_overrides
        # Override any frontmatter as required
        @release.ext_data.dig('frontmatter', @release.version) || {}
      end

      def configuration
        { 'configuration' => @release.configuration_parameters_table }
      end
    end
  end
end
