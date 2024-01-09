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
          .merge!(metadata)
          .merge!(page_attributes)
          .merge!(frontmatter_overrides)
          .merge!(extn_data)
          .merge!(release_data)

        @data
      end

      def page_attributes # rubocop:disable Metrics/MethodLength
        {
          'is_latest' => @release.latest?,
          'seo_noindex' => @release.latest? ? nil : true,
          'version' => @release.version,
          'extn_slug' => @release.name,
          'extn_publisher' => @release.vendor,
          'extn_release' => @release.version,
          'extn_icon' => extn_icon,
          'layout' => layout,
          'page_type' => 'plugin',
          'book' => "plugins/#{@release.vendor}/#{@release.name}/#{@release.version}",
          'hub_examples' => hub_examples,
          'schema' => schema,
          'badges' => badges
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

      def metadata
        @release.metadata
      end

      def hub_examples
        return unless @release.schema

        ::Jekyll::Drops::Plugins::HubExamples.new(
          schema: @release.schema,
          example: @release.schema.example,
          targets: ::Jekyll::InlinePluginExample::Config::TARGETS,
          formats: %i[curl konnect yaml kubernetes]
        )
      end

      def schema
        Jekyll::Drops::Plugins::Schema.new(
          schema: @release.schema,
          metadata: @release.metadata
        )
      end

      def extn_data
        { 'extn_data' => @release.ext_data.slice('strategy', 'releases') }
      end

      def release_data
        release = Jekyll::GeneratorSingleSource::Product::Edition
                  .new(edition: 'gateway', site: @release.site)
                  .releases
                  .detect { |r| r.value == Utils::Version.to_release(@release.version) }

        if release
          { 'release' => release.to_liquid, 'versions' => release.versions }
        else
          {}
        end
      end

      def badges
        Jekyll::Drops::Plugins::Badges.new(
          metadata: @release.metadata,
          publisher: @release.vendor
        )
      end
    end
  end
end
