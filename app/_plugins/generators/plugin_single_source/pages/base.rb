# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Base # rubocop:disable Metrics/ClassLength
      attr_reader :site, :release, :file
      attr_accessor :sidenav

      def self.make_for(release:, file:, source_path:)
        page = new(release:, file:, source_path:)

        return nil unless page.generate?

        page
      end

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
                  .merge!(frontmatter_attributes)
                  .merge!(i18n_attributes)
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

      def gateway_release
        @gateway_release ||= @site.data.dig('editions', 'gateway')
                                  .releases.detect { |r| r.value == @release.version }&.to_s || @release.version
      end

      def source_file
        @source_file ||= File.expand_path(
          @file,
          @source_path
        ).gsub("#{@site.source}/", '')
      end

      def base_url
        @base_url ||= "/hub/#{@release.dir}/"
      end

      def breadcrumb_title
        raise NotImplementedError, 'implement this in subclass'
      end

      def edit_link
        "https://github.com/Kong/docs.konghq.com/edit/#{@site.config['git_branch']}/app/#{source_file}"
      end

      def breadcrumbs
        [
          { text: category_title, url: category_url },
          { text: @release.metadata['name'], url: permalink.split('/').tap(&:pop).join('/').concat('/') },
          { text: breadcrumb_title, url: permalink }
        ]
      end

      def generate?
        min, max = frontmatter_attributes
                   .fetch_values('minimum_version', 'maximum_version') { |_k, v| v }
        return true if min.nil? && max.nil?

        Utils::Version.in_range?(@release.version, min:, max:)
      end

      private

      def url_attributes
        @url_attributes ||= {
          'permalink' => permalink,
          'canonical_url' => canonical_url,
          'source_file' => source_file
        }
      end

      def page_attributes
        @page_attributes ||= {
          'ssg_hub' => ssg_hub,
          'layout' => layout,
          'title' => page_title,
          'versions_dropdown' => ::Jekyll::Drops::Plugins::VersionsDropdown.new(self),
          'breadcrumbs' => ::Jekyll::Drops::Plugins::Breadcrumbs.new(breadcrumbs).breadcrumbs,
          'sidenav' => sidenav,
          'edit_link' => edit_link
        }
      end

      def category_url
        categories = @release.metadata['categories']
        return nil if categories.nil?

        "/hub/?category=#{categories.first}"
      end

      def category_title
        categories = @release.metadata['categories']
        return nil if categories.nil? # This happens when the plugin is not categorized

        @site_categories ||= @site.data['extensions']['categories']

        cat = @site_categories.detect { |category| category['slug'] == categories.first }
        return categories[0] if cat.nil?

        cat['name']
      end

      def layout
        'plugins/show'
      end

      def frontmatter_attributes
        return {} if @file.nil?
        return {} unless File.exist?(File.expand_path(@file, @source_path))

        @frontmatter_attributes ||= Utils::FrontmatterParser.new(
          File.read(File.expand_path(@file, @source_path))
        ).frontmatter
      end

      def i18n_attributes
        Jekyll::Pages::TranslationMissingData.new(@site).data
      end
    end
  end
end
