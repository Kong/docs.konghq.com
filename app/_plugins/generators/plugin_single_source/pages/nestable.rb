# frozen_string_literal: true

module PluginSingleSource
  module Pages
    module Nestable
      def canonical_url
        "#{base_url}#{file_to_url_segment}/".gsub('//', '/')
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/#{file_to_url_segment}/"
        end.gsub('//', '/')
      end

      def nav_title
        @nav_title ||= ::Utils::FrontmatterParser
                       .new(File.read(File.expand_path(@file, @source_path)))
                       .frontmatter.fetch('nav_title', 'Missing nav_title')
      end

      def file_to_url_segment
        @file_to_url_segment ||= @file
                                 .gsub('_index', '')
                                 .gsub('_', '')
                                 .gsub('.md', '')
                                 .delete_suffix('/')
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/#{file_to_url_segment}/".gsub('//', '/')
      end
    end
  end
end
