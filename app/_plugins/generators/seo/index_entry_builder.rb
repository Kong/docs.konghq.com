# frozen_string_literal: true

module SEO
  class IndexEntryBuilder
    GLOBAL_PAGES = %w[changelog].freeze

    def self.for(page)
      new(page).build
    end

    def initialize(page)
      @page = page
    end

    def build # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      return IndexEntry::UnprocessablePage.new(@page) if asset?
      return IndexEntry::HubPage.for(@page) if hub_page?
      return IndexEntry::OasPage.new(@page) if oas_page?

      # We only want to process the following cases:
      # * It's a global page e.g. /changelog/
      # * It's a versioned page, in the format /x.y.z/ or /latest/
      if global_page?
        IndexEntry::GlobalPage.new(@page)
      elsif product_page?
        if versioned_page?
          IndexEntry::VersionedPage.new(@page)
        else
          IndexEntry::UnversionedProductPage.new(@page)
        end
      elsif unprocessable_page?
        IndexEntry::UnprocessablePage.new(@page)
      else
        IndexEntry::NonProductPage.new(@page)
      end
    end

    private

    def asset?
      @page.url.start_with?('/assets/')
    end

    def oas_page?
      @page.relative_path.start_with?('_api/')
    end

    def hub_page?
      @page.path.start_with?('_hub') || @page.url.start_with?('/hub/')
    end

    def product_page?
      return false unless @page.data['edition']

      Jekyll::GeneratorSingleSource::Product::Edition
        .all(site: @page.site)
        .keys.include?(@page.data['edition'])
    end

    def global_page?
      GLOBAL_PAGES.include?(url_segments[1])
    end

    def versioned_page?
      return false unless @page.data['has_version']

      Gem::Version.correct?(Utils::Version.to_semver(@page.data['release'].value))
    end

    def unprocessable_page?
      ['/404.html', '/moved_urls.yml', '/redirects.json', '/robots.txt'].include?(@page.url)
    end

    def url_segments
      @url_segments ||= begin
        segments = @page.url.split('/')
        segments.shift # Remove the first empty segment
        segments
      end
    end
  end
end
