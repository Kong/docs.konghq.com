# frozen_string_literal: true

module Jekyll
  module Drops
    class SidenavMenuItem < Liquid::Drop
      def initialize(item:, options:) # rubocop:disable Lint/MissingSuper
        @item = item
        @options = options
      end

      def url
        return unless @item['url']

        @url ||= if @item['absolute_url']
                   handle_index_page(::Utils::CanonicalUrl.generate(@item['url']))
                 else
                   standardize_url([@options['docs_url'], @options['version'], @item['url']].join('/'))
                 end
      end

      def icon
        @icon ||= @item['icon']
      end

      def label
        @label ||= @item['title'] || @item['text']
      end

      def target_blank
        @target_blank ||= @item['target_blank']
      end

      def items
        @items ||= @item.fetch('items', []).compact.map do |item|
          SidenavMenuItem.new(item:, options: @options)
        end
      end

      def hash
        @hash ||= "#{@options['docs_url']}-#{@options['version']}-#{@options['plugin-key']}-#{url}".hash
      end

      private

      def handle_index_page(url)
        return url if url.start_with?('http')
        return url unless release&.label
        return url if url != "/#{release.edition}/#{release.value}/"

        # Product index pages that are unreleased
        # have the actual release number in them,
        # replace it with its label
        url.gsub("/#{release.value}/", "/#{release.label}/")
      end

      def standardize_url(url)
        # Make sure that we add the trailing / before any URL fragment
        parts = url.split('#')
        parts[0] = parts[0].prepend('/').concat('/').gsub(%r{/+}, '/')
        parts.join('#')
      end

      def release
        @release ||= edition.releases.detect do |r|
          r.label == @options['version'] ||
            r.value == ::Utils::Version.to_release(@options['version'])
        end
      end

      def edition
        @edition ||= Jekyll::GeneratorSingleSource::Product::Edition
                     .new(edition: @options['docs_url'], site: Jekyll.sites.first)
      end
    end

    class Sidenav < Liquid::Drop
      def initialize(config, options = {}) # rubocop:disable Lint/MissingSuper
        @config = config
        @options = options
      end

      def nav_items
        @nav_items ||= @config.compact.map do |item|
          SidenavMenuItem.new(item:, options: @options)
        end
      end

      def hash
        @hash ||= "#{@options['docs_url']}-#{@options['version']}-#{@options['plugin-key']}".hash
      end
    end
  end
end
