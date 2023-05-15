# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class HowTo < Base
      def canonical_url
        "#{base_url}#{file_to_url_segment}/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{@release.version}/#{file_to_url_segment}/"
        end
      end

      def page_title
        "Using the #{@release.metadata['name']} plugin"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/#{file_to_url_segment}/"
      end

      def nav_title
        @nav_title ||= ::Utils::FrontmatterParser
                       .new(File.read(File.expand_path(@file, @source_path)))
                       .frontmatter.fetch('nav_title', 'Missing nav_title')
      end

      def breadcrumb_title
        page_title
      end

      private

      def file_to_url_segment
        @file_to_url_segment ||= @file
                                 .gsub('_index', '')
                                 .gsub('_', '')
                                 .gsub('.md', '')
                                 .delete_suffix('/')
      end

      def ssg_hub
        false
      end
    end
  end
end
