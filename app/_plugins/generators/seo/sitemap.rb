# frozen_string_literal: true

module SEO
  class Sitemap
    EXCLUDED = [
      '/404.html',
      '/redirects.json',
      '/robots.txt',
      '/sitemap.xml'
    ].freeze

    def self.generate(seo_index)
      new(seo_index).generate
    end

    def initialize(seo_index)
      @seo_index = seo_index
    end

    def generate
      # At this point we have a large map of URLs with the version
      # replaced with /VERSION/, and the latest available version
      # stored in the values.
      #
      # Let's loop through every page in the site and check if there's
      # a canonical link that matches the current URL
      process_entries

      generate_sitemap
    end

    private

    def process_entries
      @seo_index.entries.map { |e| e.process!(@seo_index.index) }
    end

    def generate_sitemap
      # Set the frequency and priority values for the sitemap to use
      filtered_entries.map do |entry|
        {
          'url' => entry['page']['url'],
          'changefreq' => 'weekly',
          'priority' => '1.0'
        }
      end
    end

    def filtered_entries
      # Remove any pages that should not be in the sitemap
      @filtered_entries ||= @seo_index.index.values.filter do |entry|
        next false if entry['page'].data['seo_noindex']
        next false if entry['page'].data['redirect_to'] # Legacy HTML based redirects from jekyll-redirect-from
        next false if EXCLUDED.include?(entry['url'])

        true
      end
    end
  end
end
