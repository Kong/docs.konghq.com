module CanonicalUrl
  class Generator < Jekyll::Generator
    priority :low
    def generate(site)
      latestCeVersion = site.data["kong_versions_ce"].last['release']
      latestEeVersion = site.data["kong_versions_ee"].last['release']

      allPages = {}
      # Build a map of the latest available version of every URL
      site.pages.each do |page|
        #next unless page.url.include?("/install-and-run/docker")

        # We don't want to index these pages in the sitemap or in Google
        if ['/enterprise/', '/gateway-oss/', '/getting-started-guide/'].any? { |u| page.url.include?(u) }
          page.data['seo_noindex'] = true
        end

        parts = page.url.split("/")
        parts.shift # Remove the first empty segment

        # If we want to keep track of the latest version
        products_with_latest = ["gateway", "gateway-oss", "enterprise", "mesh", "kubernetes-ingress-controller", "deck"]
        if products_with_latest.include? parts[0] 
          # Skip any pages that don't contain a version section
          next unless /^\d+\.\d+\.x$/.match(parts[1]) || parts[1] == "latest"

          version = to_version(parts[1])
          url = page.url.gsub(parts[1], "VERSION")

          # Special case for `gateway-oss` and `enterprise`
          # As a newer version may exist under /gateway/
          url.gsub!("/gateway-oss/", "/gateway/")
          url.gsub!("/enterprise/", "/gateway/")

          # Work out the highest available URL for this path
          if !allPages[url] || (version > allPages[url]['version'])
            allPages[url] = {
              'version' => version,
              'url' => page.url,
              'sitemap' => page.data['seo_noindex'] ? false : true
            }
          end
        # Otherwise it's unversioned and should always be in the sitemap
        # unless explicitly excluded
        else
          allPages[page.url] = {
            'url' => page.url,
            'sitemap' => page.data['seo_noindex'] ? false : true
          }
        end
      end

      # Set the canonical URL for each
      site.pages.each do |page|
        parts = page.url.split("/")
        parts.shift # Remove the first empty segment

        products_with_latest = ["gateway", "gateway-oss", "enterprise", "mesh", "kubernetes-ingress-controller", "deck"]
        if products_with_latest.include? parts[0]
          # Skip any pages that don't contain a version section
          next unless /^\d+\.\d+\.x$/.match(parts[1]) || parts[1] == "latest"

          url = page.url.gsub(parts[1], "VERSION")

          # Special case for `gateway-oss` and `enterprise`
          # As a newer version may exist under /gateway/
          gatewayUrl = url.gsub("/gateway-oss/", "/gateway/").gsub("/enterprise/", "/gateway/")

          [url, gatewayUrl].each do |u|
            # Special case for /PRODUCT/VERSION urls as they are redirected to /PRODUCT/
            if parts.size == 2
              page.data['canonical_url'] = "/#{parts[0]}/"
            end

            has_match = allPages[u]
            if has_match
              page.data['canonical_url'] = has_match['url']
            end

            # We only want to index the /latest/ URLs
            if page.data['canonical_url'] && parts[1] != "latest"
              page.data['seo_noindex'] = true 
            end
          end
        end

      end

      # Save the list of pages to generate a sitemap
      site.data['sitemap_pages'] = allPages.values.filter { |v| 
        next false unless v['sitemap'] 

        # Remove unwanted URLs
        next false if [
          "/404.html",
          "/redirects.json"
        ].any? { |blocked| v['url'] == blocked }

        true
      }.map { |p|
        {
          'url' => p['url'],
          'changefreq' => 'weekly',
          'priority' => '1.0'
        }
      }
    end

    def to_version(input)
      # Latest should always be the top value
      return Gem::Version.new("9999.9.9") if input == "latest"
      Gem::Version.new(input.gsub(/\.x$/, ".0"))
    end
  end
end
