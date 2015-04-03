module Jekyll

  class Test < Jekyll::Generator
    def generate(site)
      # Add a `version` property to every versioned page
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        if site.config["documentation"] == parts[0]
          page.data["kong_version"] = parts[1]
        end
      end

      # Retrieve the latest version and put it in `site.data.kong_latest`
      latest = site.data["kong_versions"].last
      site.data["kong_latest"] = latest
    end
  end

end
