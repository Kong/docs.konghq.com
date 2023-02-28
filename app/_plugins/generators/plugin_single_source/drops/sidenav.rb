# frozen_string_literal: true

module PluginSingleSource
  module Drops
    class SidenavMenuItem < Liquid::Drop
      def self.make_for(options = {})
        if options[:url]
          SidenavMenuLink.new(options)
        elsif options[:items]
          SidenavMenuAccordion.new(options)
        else
          raise "Unsupported sidenav menu item #{options}"
        end
      end

      def initialize(options) # rubocop:disable Lint/MissingSuper
        @options = options
      end

      def url; end

      def icon
        @icon ||= @options[:icon]
      end

      def label
        @label ||= @options[:title] || @options[:text]
      end
    end

    class SidenavMenuLink < SidenavMenuItem
      def items
        []
      end

      def url
        @url ||= @options.fetch(:url)
      end
    end

    class SidenavMenuAccordion < SidenavMenuItem
      def items
        @items ||= @options.fetch(:items).map do |i|
          SidenavMenuItem.make_for(i)
        end
      end
    end

    class Sidenav < Liquid::Drop
      def initialize(config) # rubocop:disable Lint/MissingSuper
        @config = config
      end

      def nav_items
        @nav_items ||= @config.map { |i| SidenavMenuItem.make_for(i) }
      end
    end
  end
end
