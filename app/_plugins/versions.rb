
module Jekyll

  class Versions < Jekyll::Generator
    priority :highest

    def generate(site)
      ceVersions = site.data["kong_versions"].select do |elem|
        !(elem["edition"] && elem["edition"] == "enterprise")
      end

      eeVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == "enterprise"
      end

      site.data["kong_versions"] = ceVersions
      site.data["kong_versions_ee"] = eeVersions

      # Retrieve the latest version and put it in `site.data.kong_latest.version`
      latestVersion = ceVersions.last
      latestVersionEE = eeVersions.last

      site.data["kong_latest"] = latestVersion

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        page.data["has_version"] = true
        # Only apply those rules to documentation pages
        if (parts[0] == "enterprise" || parts[0].match?(/[0-3]\.[0-9]{1,2}.*$/))
          if(parts[0] == 'enterprise')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = eeVersions
            page.data["kong_latest"] = latestVersionEE
            page.data["nav_items"] = site.data['docs_nav_ee_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/enterprise', 1, parts, latestVersionEE["release"])
          else
            page.data["edition"] = "community"
            page.data["kong_version"] = parts[0]
            page.data["kong_versions"] = ceVersions
            page.data["kong_latest"] = latestVersion
            page.data["nav_items"] = site.data['docs_nav_' + parts[0].gsub(/\./, '')]
            createAliases(page, '', 0, parts, latestVersion["release"])
          end

          # Helpful boolean in templates. If version has .md, then it is not versioned
          if page.data["kong_version"].include? ".md"
            page.data["has_version"] = false
          end
        end
      end
    end

    def createAliases(page, urlPath, offset, parts, latestRelease)
      # Alias latest docs folder /x.x.x to /latest
      releasePath = parts[0 + offset]
      templateName = parts[1 + offset]

      if releasePath == latestRelease
        page.data["alias"] = "/" + page.path.sub(releasePath, "latest").sub(/\..*$/, "")
        if templateName == "index.md"
          # the / page
          page.data["permalink"] = "#{urlPath}/"
          page.data["alias"] = ["#{urlPath}/latest", "#{urlPath}/#{latestRelease}/index.html"]
        elsif /index\.(md|html)/.match(parts.last)
          # all other nested index pages
          # /latest/plugin-development/index/index.html -> /latest/plugin-development/index.html
          page.data["alias"] = page.data["alias"].sub(/index/, "")
        end
      end
    end
  end
end
