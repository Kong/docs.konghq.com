module CanonicalUrl
  class Generator < Jekyll::Generator
    priority :low
    def generate(site)

      latestCeVersion = site.data["kong_versions_ce"].last['release']
      latestEeVersion = site.data["kong_versions_ee"].last['release']

      site.pages.each do |page|
        # Reset variables
        highestVersionUrl = nil
        parts = Pathname(page.path).each_filename.to_a
        
        products_with_latest = ["gateway", "gateway-oss", "enterprise", "mesh", "kubernetes-ingress-controller", "deck"]
        next unless products_with_latest.include? parts[0]

        latestUrl = page.url.gsub(parts[1], "latest")

        # Exception for /gateway-oss/ and /enterprise/
        latestUrl = latestUrl.gsub(/\/(gateway\-oss|enterprise)\//, "/gateway/")
        if (parts[0] == "gateway-oss")
          highestVersionUrl = page.url.gsub(parts[1], latestCeVersion)
        elsif (parts[0] == "enterprise")
          highestVersionUrl = page.url.gsub(parts[1], latestEeVersion)
        end

        # Is there a URL that matches?
        has_match = site.pages.detect { |p| p.url == latestUrl }

        # Check the latest version of gateway-oss and enterprise too
        # If there's not a /latest/ version in gateway
        if highestVersionUrl && !has_match
          puts highestVersionUrl if page.url.include?("2.3.x")
          has_match = site.pages.detect { |p| p.url == highestVersionUrl }
        end

        if has_match
          page.data['canonical_url'] = has_match.url
        end
      end
    end
  end
end
