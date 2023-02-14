# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class HowTo < Base
      private

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

      def file_to_url_segment
        @file.gsub('_index', '').gsub('_', '').gsub('.md', '').delete_suffix('/')
      end

      def ssg_hub
        false
      end
    end
  end
end
