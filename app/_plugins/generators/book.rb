# frozen_string_literal: true

module Jekyll
  class Books < Jekyll::Generator
    priority :low
    def generate(site) # rubocop:disable Metrics/PerceivedComplexity, Metrics/CyclomaticComplexity, Metrics/AbcSize, Metrics/MethodLength
      books = {}

      site.pages.each do |page|
        next unless page.data.key?('book')

        v = page.data['release']
        v = 'latest' if page.data['is_latest']
        (books["#{page.data['edition']}/#{v}/#{page.data['book']}"] ||= []).push(page)
      end

      books.each do |name, pages|
        unless name.start_with? '//plugins'
          # Sort pages by page number
          pages.sort! { |a, b| a.data['chapter'] <=> b.data['chapter'] }
        end

        # Insert next and previous link
        pages.each_with_index do |page, idx|
          page.data['book'] = {
            'chapters' => {}
          }

          page.data['book']['previous'] = pages[idx - 1] if idx.positive?
          page.data['book']['next'] = pages[idx + 1] if idx < pages.size - 1

          # Add all existing pages links to this page
          pages.each do |p|
            if p.data['page_type'] == 'plugin'
              page.data['book']['chapters'][p.path] = p.url.gsub('.html', '/') if p.path != page.path
            else
              p_basename = p.basename
              page.data['book']['chapters'][p_basename] = p.url if p_basename != page.basename
            end
          end
        end
      end
    end
  end
end
