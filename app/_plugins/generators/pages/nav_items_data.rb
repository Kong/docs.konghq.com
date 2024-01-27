# frozen_string_literal: true

require_relative 'productable'

module Jekyll
  module Pages
    class NavItemsData
      include Jekyll::Pages::Productable

      def initialize(site:, page:)
        @site = site
        @page = page
      end

      def process!
        return unless products.include?(product)

        set_nav_items
        set_sidenav
        set_releases_dropdown
      end

      private

      def set_nav_items
        # Clean up nav_items for generated pages as there's an
        # additional level of nesting
        @page.data['nav_items'] ||= nav_items
        @page.data['nav_items'] = @page.data['nav_items']['items'] if @page.data['nav_items'].is_a?(Hash)
      end

      def set_sidenav
        @page.data['sidenav'] = DocsSingleSource::Sidenav.new(@page).generate
      end

      def set_releases_dropdown
        @page.data['releases_dropdown'] = Drops::ReleasesDropdown.new(@page)
      end

      def product_abbrv
        case product
        when 'kubernetes-ingress-controller'
          'kic'
        when 'gateway-operator'
          'kgo'
        else
          product
        end
      end

      def nav_items
        if release
          @site.data["docs_nav_#{product_abbrv}_#{release.value.gsub(/\./, '')}"]
        else
          @site.data["docs_nav_#{product_abbrv}"]
        end
      end

      def release
        @release ||= @page.data['release']
      end
    end
  end
end
