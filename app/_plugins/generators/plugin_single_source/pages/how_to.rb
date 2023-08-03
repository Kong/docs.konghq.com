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

      def breadcrumbs
        [
          { text: category_title, url: category_url },
          { text: @release.metadata['name'], url: base_how_to_url },
          { text: 'How to', url: how_to_url },
          { text: breadcrumb_title, url: permalink }
        ]
      end

      private

      def base_how_to_url
        base_path = permalink.split('/').tap(&:pop)
        if @release.latest?
          base_path.take(4)
        else
          base_path.take(5) # include version
        end.join('/').concat('/')
      end

      def how_to_url
        return unless index_file_exist?

        base_how_to_url.concat('how-to/')
      end

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

      def index_file_exist?
        File.exist?(File.expand_path('how-to/_index.md', @source_path))
      end
    end
  end
end
