
module Jekyll

  class Versions < Jekyll::Generator
    priority :highest

    def generate(site)
      ceVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == "community"
      end

      eeVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == "enterprise"
      end

      studioVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'studio'
      end

      gsgVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'getting-started-guide'
      end

      deckVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'deck'
      end

      meshVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'mesh'
      end

      kicVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'kubernetes-ingress-controller'
      end

      site.data["kong_versions"] = ceVersions
      site.data["kong_versions_ee"] = eeVersions
      site.data["kong_versions_studio"] = studioVersions
      site.data["kong_versions_gsg"] = gsgVersions
      site.data["kong_versions_deck"] = deckVersions
      site.data["kong_versions_mesh"] = meshVersions
      site.data["kong_versions_kic"] = kicVersions


      # Retrieve the latest version and put it in `site.data.kong_latest.version`
      latestVersion = ceVersions.last
      latestVersionEE = eeVersions.last
      latestVersionStudio = studioVersions.last
      latestVersionGSG = gsgVersions.last
      latestVersionDeck = deckVersions.last
      latestVersionMesh = meshVersions.last
      latestVersionKIC = kicVersions.last

      site.data["kong_latest"] = latestVersion

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        page.data["has_version"] = true
        # Only apply those rules to documentation pages
        if (parts[0] == "enterprise" || parts[0].match(/[0-3]\.[0-9]{1,2}(\..*)?$/) || parts[0] == 'studio' || parts[0] == 'getting-started-guide' || parts[0] == 'mesh' || parts[0] == 'deck' || parts[0] == 'kubernetes-ingress-controller' || parts[0] == 'community')
          if(parts[0] == 'enterprise')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = eeVersions
            page.data["kong_latest"] = latestVersionEE
            page.data["nav_items"] = site.data['docs_nav_ee_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/enterprise', 1, parts, latestVersionEE["release"])
          elsif(parts[0] == 'studio')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = studioVersions
            page.data["kong_latest"] = latestVersionStudio
            page.data["nav_items"] = site.data['docs_nav_studio_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/studio', 1, parts, latestVersionStudio["release"])
          elsif(parts[0] == 'getting-started-guide')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = gsgVersions
            page.data["kong_latest"] = latestVersionGSG
            page.data["nav_items"] = site.data['docs_nav_gsg_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/getting-started-guide', 1, parts, latestVersionGSG["release"])
          elsif(parts[0] == 'mesh')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = meshVersions
            page.data["kong_latest"] = latestVersionMesh
            page.data["nav_items"] = site.data['docs_nav_mesh_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/mesh', 1, parts, latestVersionMesh["release"])
          elsif(parts[0] == 'kubernetes-ingress-controller')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = kicVersions
            page.data["kong_latest"] = latestVersionKIC
            page.data["nav_items"] = site.data['docs_nav_kic_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/kubernetes-ingress-controller', 1, parts, latestVersionKIC["release"])
          elsif(parts[0] == 'deck')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = deckVersions
            page.data["kong_latest"] = latestVersion
            page.data["nav_items"] = site.data['docs_nav_deck']
            createAliases(page, '/deck', 1, parts, latestVersion["release"])
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
