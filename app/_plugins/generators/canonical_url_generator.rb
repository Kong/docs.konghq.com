# frozen_string_literal: true

module CanonicalUrl
  class Generator < Jekyll::Generator # rubocop:disable Metrics/ClassLength
    priority :low
    def generate(site)
      # Generate the all_pages entres for the Plugin Hub
      all_pages = generate_plugin_hub(site)

      # Build up an index of the latest URLs for each page
      all_pages = all_pages.merge(
        build_latest_url_index(site)
      )

      # At this point we have a large map of URLs with the version
      # replaced with /VERSION/, and the latest available version
      # stored in the values.
      #
      # Let's loop through every page in the site and check if there's
      # a canonical link that matches the current URL
      set_canonical_and_noindex(site, all_pages)

      # Finally, build a list of pages to be used by the sitemap template
      site.data['sitemap_pages'] = build_sitemap(all_pages)
    end

    def build_latest_url_index(site) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      all_pages = {}
      # Build a map of the latest available version of every URL
      site.pages.each do |page| # rubocop:disable Metrics/BlockLength
        # We don't want to index some pages in the sitemap or in Google
        handle_blocked_products(page)

        # We inspect the first couple of segments to work out
        # what type of page we're on
        url_segments = page.url.split('/')
        url_segments.shift # Remove the first empty segment

        # If it's an unversioned URL, always add it to the list of pages
        unless versioned_product?(url_segments[0])
          all_pages[page.url] = {
            'url' => page.url,
            'page' => page
          }
          next
        end

        # We always want to run on specific pages, even within a versioned docset
        is_global_page = url_segments[1] == 'changelog'

        # We only want to process the following cases:
        # * It's a versioned page (in the format /x.y.z/)
        # * It's the /latest/ page
        # * It's a global page e.g. /changelog/
        next unless versioned_page?(url_segments) || is_global_page

        # If it's a global page, there's only one version of it
        # by definition so it always needs adding to the list of pages.
        # We set the version to "latest" for this URL to ensure that it's
        # always added to the index
        if is_global_page
          version = to_version('latest')
          url = page.url
          page.data['is_latest'] = true

        # Otherwise it has a version (\d+ match or /latest/), so let's
        # Keep track of that for use later
        else
          version = to_version(url_segments[1])
          url = page.url.gsub(url_segments[1], 'VERSION')

          # URLs under the /gateway-oss/ and /enterprise/ paths can
          # never be canonical as they're set to noindex
          #
          # Instead, check if a matching URL exists under /gateway/
          # which CAN be canonical
          url = url.gsub('/gateway-oss/', '/gateway/').gsub('/enterprise/', '/gateway/')
        end

        # Work out the highest available URL for this path
        next unless !all_pages[url] || (version > all_pages[url]['version'])

        all_pages[url] = {
          'version' => version,
          'url' => page.url,
          'page' => page
        }
      end

      all_pages
    end

    def set_canonical_and_noindex(site, all_pages) # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity, Metrics/MethodLength, Metrics/PerceivedComplexity
      site.pages.each do |page|
        url_segments = page.url.split('/')
        url_segments.shift # Remove the first empty segment

        # We only need to perform this check for products that we know
        # are versioned
        next unless versioned_product?(url_segments[0])

        # Skip any pages that don't contain a version section
        next unless versioned_page?(url_segments)

        urls_to_check = []
        # We're looking for pages in the format /product/VERSION/other/segments
        # So replace the current version with the literal "VERSION"
        url = page.url.gsub(url_segments[1], 'VERSION')
        urls_to_check << url

        # As before, legacy endpoints might match newer /gateway/ URLs so
        # we also need to check for the path under the /gateway/ docs too
        legacy_gateway_endpoints = ['/gateway-oss/', '/enterprise/']
        legacy_gateway_endpoints.each do |old|
          urls_to_check << url.gsub(old, '/gateway/') if url.include?(old)
        end

        # There will usually only be one URL to check, but gateway-oss
        # and enterprise URLs will contain two here, so we have to loop
        urls_to_check.each do |u|
          # Otherwise look up the URL and link to the latest version
          matching_url = all_pages[u]
          page.data['canonical_url'] = matching_url['url'] if matching_url
        end

        # If a page has a canonical URL and is not the /latest/ page,
        # we don't want it in the sitemap or indexable by Google
        #
        # This will prevent indexing of old gateway-oss content
        # that has a canonical URL e.g. /enterprise/2.4.x/clustering/
        # which has a canonical link to /enterprise/2.5.x/clustering/
        #
        # This is intentional, as we do not want to index anything except
        # the latest, or unversioned pages. There is a risk that these older
        # pages have changed URL and the content exists in a similar form.
        # If this is the case, we may get hit by duplicate content penalties.
        page.data['seo_noindex'] = true if page.data['canonical_url'] && url_segments[1] != 'latest'
      end
    end

    def versioned_page?(url_segments)
      /^\d+\.\d+\.x$/.match(url_segments[1]) || url_segments[1] == 'latest'
    end

    def versioned_product?(product)
      # These are versioned products, and we want the canonical to be /latest/
      # for them all
      products_with_latest = %w[gateway gateway-oss enterprise mesh kubernetes-ingress-controller deck]
      products_with_latest.include? product
    end

    def handle_blocked_products(page)
      blocked_products = ['/enterprise/', '/gateway-oss/', '/getting-started-guide/']
      page.data['seo_noindex'] = true if blocked_products.any? { |u| page.url.include?(u) }
    end

    def build_sitemap(pages) # rubocop:disable Metrics/MethodLength
      # These files should NOT be in the sitemap
      blocked_from_sitemap = [
        '/404.html',
        '/redirects.json',
        '/robots.txt',
        '/sitemap.xml'
      ]

      # Remove any pages that should not be in the sitemap
      pages = pages.values.filter do |v|
        next false if v['page'].data['seo_noindex']
        next false if v['page'].data['redirect_to'] # Legacy HTML based redirects from jekyll-redirect-from
        next false if blocked_from_sitemap.any? { |blocked| v['url'] == blocked }

        true
      end

      # Set the frequency and priority values for the sitemap to use
      pages.map do |p|
        {
          'url' => p['url'],
          'changefreq' => 'weekly',
          'priority' => '1.0'
        }
      end
    end

    def generate_plugin_hub(site) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      all_pages = {}
      # Set the canonical URL for plugin pages + add them to the sitemap
      site.collections['hub'].docs.each do |page|
        # Special case for the index page
        if page.url == '/hub/'
          page.data['canonical_url'] = page.url
          all_pages[page.url] = {
            'url' => page.url,
            'page' => page
          }
          next
        end

        url_segments = page.url.split('/')
        if url_segments.last == 'index'
          url = page.url.gsub('/index', '/')
          all_pages[url] = {
            'url' => url,
            'page' => page
          }
          page.data['canonical_url'] = url
        else
          # It's an old version, so set the canonical URL
          # and noindex
          url_segments.pop # Remove the version at the end
          page.data['canonical_url'] = "#{url_segments.join('/')}/"
          page.data['seo_noindex'] = true
        end
      end
      all_pages
    end

    def to_version(input)
      # Latest should always be the top value
      return Gem::Version.new('9999.9.9') if input == 'latest'

      Gem::Version.new(input.gsub(/\.x$/, '.0'))
    end
  end
end
