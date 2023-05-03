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
                   if @item['url'].end_with?('/')
                     @item['url']
                   else
                     @item['url'].concat('/')
                   end
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
        @items ||= @item.fetch('items', []).map do |item|
          SidenavMenuItem.new(item:, options: @options)
        end
      end

      def hash
        "#{@options['docs_url']}-#{@options['version']}-#{url}"
      end

      private

      def standardize_url(url)
        url.prepend('/').concat('/').gsub(%r{/+}, '/')
      end
    end

    class Sidenav < Liquid::Drop
      def initialize(config, options = {}) # rubocop:disable Lint/MissingSuper
        @config = config
        @options = options
      end

      def nav_items
        @nav_items ||= @config.map do |item|
          SidenavMenuItem.new(item:, options: @options)
        end
      end

      def hash
        "#{@options['docs_url']}-#{@options['version']}"
      end
    end
  end
end
