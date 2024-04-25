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
        @content ||= begin
          file_name = if @release.missing_translation?
                        i18n_file.full_file_path_in_default_locale
                      else
                        i18n_file.full_file_path_in_locale
                      end
          Utils::SafeFileReader.read(file_name:, source_path: '')
        end
      end

      def dir
        @dir ||= "hub/#{@release.dir}"
      end

      def gateway_release
        @gateway_release ||= @site.data.dig('editions', 'gateway')
                                  .releases.detect { |r| r.value == @release.version }&.to_s || @release.version
      end

      def source_file
        @source_file ||= i18n_file.relative_file_path
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
        return {} unless File.exist?(i18n_file.full_file_path_in_locale)

        @frontmatter_attributes ||= Utils::FrontmatterParser.new(
          File.read(i18n_file.full_file_path_in_locale)
        ).frontmatter
      end

      def i18n_attributes
        return { 'locale' => I18n.default_locale.to_s } if @site.config['locale'] == I18n.default_locale.to_s

        if !@release.missing_translation? && i18n_file.exists_in_locale?
          { 'locale' => @site.config['locale'] }
        else
          Jekyll::Pages::TranslationMissingData.new(@site).data
        end
      end

      def i18n_file
        @i18n_file ||= Jekyll::GeneratorSingleSource::I18nFile.new(
          file: @file,
          src_path: @source_path.gsub("#{@site.source}/", ''),
          locale: @site.config['locale'],
          site: @site
        )
      end
    end
  end
end
