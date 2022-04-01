module CanonicalUrl
  class Generator < Jekyll::Generator
    priority :medium
    def generate(site)

      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        
        products_with_latest = ["gateway", "mesh", "kubernetes-ingress-controller", "deck"]
        next unless products_with_latest.include? parts[0]

        latestUrl = page.url.gsub(parts[1], "latest")
        # Is there a URL that matches?
        has_match = site.pages.detect { |p| p.url == latestUrl }
        if has_match
          page.data['canonical_url'] = latestUrl
        end
      end
    end
  end
end
