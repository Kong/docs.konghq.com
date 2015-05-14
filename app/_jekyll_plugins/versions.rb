module Jekyll

  class Versions < Jekyll::Generator
    def generate(site)
      # Retrieve the latest version and put it in `site.data.kong_latest.version`
      latest = site.data["kong_versions"].last
      site.data["kong_latest"] = latest

      # Add a `version` property to every versioned page
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        if site.config["documentation"] == parts[0]
          page.data["kong_version"] = parts[1]
        end
      end
    end
  end

end
