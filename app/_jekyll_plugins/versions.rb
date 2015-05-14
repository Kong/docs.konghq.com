module Jekyll

  class Versions < Jekyll::Generator
    def generate(site)
      # Retrieve the latest version and put it in `site.data.kong_latest.version`
      latest = site.data["kong_versions"].last
      site.data["kong_latest"] = latest

      # Add a `version` property to every versioned page
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        if parts[0] == site.config["documentation"]
          page.data["kong_version"] = parts[1]

          # Alias latest docs folder /docs/x.x.x to /docs/latest
          if parts[1] == latest["version"]
            page.data["alias"] = "/" + page.path.sub(parts[1], "latest").sub(/\..*$/, "")
            if parts[2] == "index.md"
              page.data["alias"] = ["/#{site.config["documentation"]}/latest", "/#{site.config["documentation"]}/#{latest["version"]}/index.html", ]
            end
          end
        end
      end
    end
  end

end
