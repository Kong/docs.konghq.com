module Jekyll

  class Versions < Jekyll::Generator
    priority :highest

    def generate(site)
      # Retrieve the latest version and put it in `site.data.kong_latest.version`
      latest = site.data["kong_versions"].last
      site.data["kong_latest"] = latest

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a

        # Only apply those rules to documentation pages
        if parts[0] == site.config["documentation"]
          page.data["kong_version"] = parts[1]

          # Put navigation items for current version in page.nav_items
          page.data["nav_items"] = site.data['docs_nav_' + parts[1].gsub(/\./, '')]

          # Alias latest docs folder /docs/x.x.x to /docs/latest
          if parts[1] == latest["release"]
            page.data["alias"] = "/" + page.path.sub(parts[1], "latest").sub(/\..*$/, "")
            if parts[2] == "index.md"
              # the /docs/ page
              page.data["permalink"] = "/docs/"
              page.data["alias"] = ["/#{site.config["documentation"]}/latest", "/#{site.config["documentation"]}/#{latest["release"]}/index.html"]
            elsif /index\.(md|html)/.match(parts.last)
              # all other nested index pages
              # /docs/latest/plugin-development/index/index.html -> /docs/latest/plugin-development/index.html
              page.data["alias"] = page.data["alias"].sub(/index/, "")
            end
          end
        end
      end
    end
  end

end
