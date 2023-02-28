# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class HowTo < Base
      def canonical_url
        "/#{base_url}#{file_to_url_segment}/"
      end

      def permalink
        if @release.latest?
          canonical_url.delete_prefix('/')
        else
          "#{base_url}#{@release.version}/#{file_to_url_segment}.html"
        end
      end

      def page_title
        "Using the #{@release.frontmatter['name']} plugin"
      end

      def dropdown_url
        @dropdown_url ||= "/#{base_url}VERSION/#{file_to_url_segment}"
      end

      private

      def file_to_url_segment
        @file_to_url_segment ||= @file.gsub('_index', '').gsub('_', '').gsub('.md', '').delete_suffix('/')
      end

      def ssg_hub
        false
      end
    end
  end
end
