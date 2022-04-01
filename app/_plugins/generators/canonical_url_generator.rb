require 'byebug'
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
        parts = page.url.split("/")
        parts.shift # Remove the first empty segment

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
            'url' => page.url
          }
        end
      end

      # Set the canonical URL for each
      site.pages.each do |page|
        parts = page.url.split("/")
        parts.shift # Remove the first empty segment

        products_with_latest = ["gateway", "gateway-oss", "enterprise", "mesh", "kubernetes-ingress-controller", "deck"]
        next unless products_with_latest.include? parts[0]

        # Skip any pages that don't contain a version section
        next unless /^\d+\.\d+\.x$/.match(parts[1]) || parts[1] == "latest"

        url = page.url.gsub(parts[1], "VERSION")

        # Special case for `gateway-oss` and `enterprise`
        # As a newer version may exist under /gateway/
        gatewayUrl = url.gsub("/gateway-oss/", "/gateway/").gsub("/enterprise/", "/gateway/")

        [url, gatewayUrl].each do |u|
          has_match = allPages[u]
          if has_match
            page.data['canonical_url'] = has_match['url']
          end
        end
      end

      # Save the list of pages to generate a sitemap
      site.data['sitemap_pages'] = allPages.values.map { |p| 
        {
          'url' => p['url'],
          'changefreq' => p['url'].include?("/latest/") ? "weekly" : "monthly",
          'priority' => p['url'].include?("/latest/") ? "1.0" : "0.5"
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
