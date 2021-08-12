
module Jekyll

  class Versions < Jekyll::Generator
    priority :highest

    def generate(site)
      ceVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'gateway-oss'
      end

      eeVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'enterprise'
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

      konnectVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'konnect'
      end

      konnectPlatformVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'konnect-platform'
      end

      kicVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'kubernetes-ingress-controller'
      end

      contributingVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'contributing'
      end

      gatewayVersions = site.data["kong_versions"].select do |elem|
        elem["edition"] && elem["edition"] == 'gateway'
      end

      site.data["kong_versions_ce"] = ceVersions
      site.data["kong_versions_ee"] = eeVersions
      site.data["kong_versions_gsg"] = gsgVersions
      site.data["kong_versions_deck"] = deckVersions
      site.data["kong_versions_mesh"] = meshVersions
      site.data["kong_versions_konnect"] = konnectVersions
      site.data["kong_versions_konnect_platform"] = konnectPlatformVersions
      site.data["kong_versions_kic"] = kicVersions
      site.data["kong_versions_contributing"] = contributingVersions
      site.data["kong_versions_gateway"] = gatewayVersions


      # Retrieve the latest version and put it in `site.data.kong_latest.version`
      latestVersionCE = ceVersions.last
      latestVersionEE = eeVersions.last
      latestVersionGSG = gsgVersions.last
      latestVersionDeck = deckVersions.last
      latestVersionMesh = meshVersions.last
      latestVersionKonnect = konnectVersions.last
      latestVersionKonnectPlatform = konnectPlatformVersions.last
      latestVersionKIC = kicVersions.last
      latestVersionContributing = contributingVersions.last
      latestVersionGateway = gatewayVersions.last

      site.data["kong_latest"] = latestVersionCE
      site.data["kong_latest_ee"] = latestVersionEE
      site.data["kong_latest_mesh"] = latestVersionMesh
      site.data["kong_latest_gsg"] = latestVersionGSG
      site.data["kong_latest_KIC"] = latestVersionKIC
      site.data["kong_latest_deck"] = latestVersionDeck
      site.data["kong_latest_gateway"] = latestVersionGateway

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        page.data["has_version"] = true
        # Only apply those rules to documentation pages
        if (parts[0] == "enterprise" || parts[0].match(/[0-3]\.[0-9]{1,2}(\..*)?$/) || parts[0] == 'getting-started-guide' || parts[0] == 'mesh' || parts[0] == 'deck' || parts[0] == 'contributing' || parts[0] == 'konnect' || parts[0] == 'konnect-platform' || parts[0] == 'kubernetes-ingress-controller' || parts[0] == 'gateway' || parts[0] == 'gateway-oss')
          if(parts[0] == 'enterprise')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = eeVersions
            page.data["kong_latest"] = latestVersionEE
            page.data["nav_items"] = site.data['docs_nav_ee_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/enterprise', 1, parts, latestVersionEE["release"])
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
          elsif(parts[0] == 'konnect')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = konnectVersions
            page.data["kong_latest"] = latestVersionKonnect
            page.data["nav_items"] = site.data['docs_nav_konnect']
            createAliases(page, '/konnect', 1, parts, latestVersionKonnect["release"])
          elsif(parts[0] == 'konnect-platform')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = konnectPlatformVersions
            page.data["kong_latest"] = latestVersionKonnectPlatform
            page.data["nav_items"] = site.data['docs_nav_konnect_platform']
            createAliases(page, '/konnect-platform', 1, parts, latestVersionKonnectPlatform["release"])
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
            page.data["kong_latest"] = latestVersionDeck
            page.data["nav_items"] = site.data['docs_nav_deck_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/deck', 1, parts, latestVersionDeck["release"])
          elsif(parts[0] == 'gateway')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = gatewayVersions
            page.data["kong_latest"] = latestVersionGateway
            page.data["nav_items"] = site.data['docs_nav_gateway_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/gateway', 1, parts, latestVersionGateway["release"])
          elsif(parts[0] == 'contributing')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = contributingVersions
            page.data["kong_latest"] = latestVersionContributing
            page.data["nav_items"] = site.data['docs_nav_contributing']
            createAliases(page, '/contributing', 1, parts, latestVersionContributing["release"])
          elsif(parts[0] == 'gateway-oss')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = ceVersions
            page.data["kong_latest"] = latestVersionCE
            page.data["nav_items"] = site.data['docs_nav_ce_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/gateway-oss', 1, parts, latestVersionCE["release"])
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
