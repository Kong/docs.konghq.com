# frozen_string_literal: true

module PluginSingleSource
  module Pages
    class Troubleshooting < Base
      def page_title
        @page_title ||= I18n.t('hub.sidebar.troubleshooting', locale: translate_to)
      end

      def breadcrumb_title
        page_title
      end

      def nav_title
        page_title
      end

      def source_file; end

      def breadcrumbs
        [
          { text: category_title, url: category_url },
          { text: @release.metadata['name'], url: base_url },
          { text: breadcrumb_title, url: permalink }
        ]
      end

      def canonical_url
        "#{base_url}troubleshooting/"
      end

      def dropdown_url
        @dropdown_url ||= "#{base_url}VERSION/troubleshooting/"
      end

      def permalink
        if @release.latest?
          canonical_url
        else
          "#{base_url}#{gateway_release}/troubleshooting/"
        end
      end

      def content
        ''
      end

      def icon
        '/assets/images/icons/hub-layout/icn-troubleshooting.svg'
      end

      def edit_link; end

      def generate?
        problems.any?
      end

      private

      def layout
        'plugins/troubleshooting'
      end

      def ssg_hub
        false
      end

      def page_attributes
        super.merge('problems' => problems)
      end

      def problems
        # Sort by weight, leaving items without weight at the end of the list
        @problems ||= process_troubleshooting_files
                      .sort_by do |p|
          [p['weight'].nil? ? Float::INFINITY : p['weight'], p['file']]
        end
      end

      def process_troubleshooting_files
        Dir.glob(File.expand_path('troubleshooting/*.md', @source_path)).map do |file|
          markdown = Utils::FrontmatterParser.new(File.read(file))
          min, max, title, weight = markdown
                                    .frontmatter
                                    .fetch_values(*frontmatter_attrs) { |_, v| v }

          next unless Utils::Version.in_range?(@release.version, min:, max:)

          { 'title' => title, 'content' => markdown.content, 'weight' => weight, 'file' => File.basename(file, '.md') }
        end.compact
      end

      def frontmatter_attrs
        %w[minimum_version maximum_version problem weight]
      end
    end
  end
end
