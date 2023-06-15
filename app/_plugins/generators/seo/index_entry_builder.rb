# frozen_string_literal: true

module SEO
  class IndexEntryBuilder
    VERSIONED_PRODUCTS = %w[
      gateway gateway-oss enterprise mesh kubernetes-ingress-controller deck
    ].freeze

    GLOBAL_PAGES = %w[changelog].freeze

    def self.for(page)
      new(page).build
    end

    def initialize(page)
      @page = page
    end

    def build
      return IndexEntry::HubPage.for(@page) if hub_page?
      return IndexEntry::UnversionedProductPage.new(@page) unless versioned_product?

      # We only want to process the following cases:
      # * It's a global page e.g. /changelog/
      # * It's a versioned page, in the format /x.y.z/ or /latest/
      if global_page?
        IndexEntry::GlobalPage.new(@page)
      elsif versioned_page?
        IndexEntry::VersionedPage.new(@page)
      else
        IndexEntry::UnprocessablePage.new(@page)
      end
    end

    private

    def hub_page?
      @page.path.start_with?('_hub') || @page.url.start_with?('/hub/')
    end

    def versioned_product?
      VERSIONED_PRODUCTS.include?(url_segments[0])
    end

    def global_page?
      GLOBAL_PAGES.include?(url_segments[1])
    end

    def versioned_page?
      /^\d+\.\d+\.x$/.match(url_segments[1]) || url_segments[1] == 'latest'
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
