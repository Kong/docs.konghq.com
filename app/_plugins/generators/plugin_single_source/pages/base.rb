# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Base
      attr_reader :site, :release

      def initialize(release:, file:, source_path:)
        @release = release
        @file = file
        @source_path = source_path
        @site = release.site
      end

      def to_jekyll_page
        SingleSourcePage.new(site: @release.site, page: self)
      end

      def data
        @data ||= Plugin::PageData
                  .generate(release: @release)
                  .merge!(url_attributes)
                  .merge!(page_attributes)
      end

      def content
        @content ||= Utils::SafeFileReader.read(
          file_name: @file,
          source_path: @source_path
        )
      end

      def dir
        @dir ||= "hub/#{@release.dir}"
      end

      def version
        @version ||= @release.version
      end

      def source_file
        @source_file ||= File.expand_path(
          @file,
          @source_path
        ).gsub("#{@site.source}/", '')
      end

      def nav_title
        @nav_title ||= ::Utils::FrontmatterParser
                       .new(File.read(File.expand_path(@file, @source_path)))
                       .frontmatter.fetch('nav_title', 'Missing nav_title')
      end

      def base_url
        @base_url ||= "/hub/#{@release.dir}/"
      end

      private

      def url_attributes
        @url_attributes ||= {
          'permalink' => permalink,
          'canonical_url' => @release.latest? ? nil : canonical_url,
          'source_file' => source_file
        }
      end

      def page_attributes
        @page_attributes ||= {
          'ssg_hub' => ssg_hub,
          'layout' => 'plugins/show',
          'title' => page_title,
          'versions_dropdown' => ::Jekyll::Drops::Plugins::VersionsDropdown.new(self),
          'breadcrumbs' => ::Jekyll::Drops::Plugins::Breadcrumbs.new(breadcrumbs).breadcrumbs
        }
      end

      def breadcrumbs
        [
          { text: 'Home', url: '/' },
          { text: 'Plugin Hub', url: '/hub/' },
          { text: @release.vendor },
          { text: @release.name, url: "#{base_url}#{@release.latest? ? '' : @release.version}" },
          { text: page_title, url: permalink }
        ]
      end
    end
  end
end
