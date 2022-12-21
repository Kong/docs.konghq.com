# frozen_string_literal: true

module Jekyll
  class NavigationLinks < Jekyll::Generator
    priority :medium

    def generate(site)
      site.pages.each_with_index do |page, index|
        next unless page.relative_path.start_with? 'docs'
        next if page.path == 'docs/index.md'

        version = Pathname(page.relative_path).each_filename.to_a[1]

        # Get all sidenav items
        nav_items = site.data["docs_nav_kuma_#{version.gsub(/\./, '')}"]['items']
        pages = pages_from_items(nav_items)

        current_page = pages.detect do |u|
          u['url'] == page_path_to_sidebar_url(page.relative_path, version)
        end

        page_index = pages.index(current_page)

        if page_index && page_index != 0
          page.data['prev'] = pages[page_index - 1]
        end

        if page_index && page_index != 0
          page.data['next'] = pages[page_index + 1]
        end
      end
    end

    def pages_from_items(items)
      items.each_with_object([]) do |i, array|
        if i.key?('url') && URI(i.fetch('url')).fragment.nil?
          array << { 'url' => i.fetch('url'), 'text' => i.fetch('text') }
        end

        if i.key?('items')
          array << pages_from_items(i.fetch('items'))
        end
      end.flatten
    end

    def page_path_to_sidebar_url(path, version)
      path.delete_prefix("docs/#{version}").gsub('.md', '/')
    end
  end
end
