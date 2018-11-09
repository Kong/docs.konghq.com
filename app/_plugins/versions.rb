
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

      # Collate version history for articles
      docs_version_history = {}
      site.data["docs_version_timeline"].map { |doc|
        docs_version_history[doc["slug"]] = doc
        unless doc["aliases"].nil?
          doc["aliases"].map { |a| docs_version_history[a] = doc }
        end
      }

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page|
        parts = Pathname(page.path).each_filename.to_a
        page.data["has_version"] = true
        # Only apply those rules to documentation pages
        if (parts[0] == "enterprise" || parts[0].include?(".x"))
          if(parts[0] == 'enterprise')
            page.data["edition"] = parts[0]
            page.data["kong_version"] = parts[1]
            page.data["kong_versions"] = eeVersions
            page.data["kong_latest"] = latestVersionEE
            page.data["nav_items"] = site.data['docs_nav_ee_' + parts[1].gsub(/\./, '')]
            createAliases(page, '/enterprise', 1, parts, latestVersionEE["release"])
            doc_slug = parts[2..-1].join("/").sub(/\.(md)$/, "").sub(/\/?index$/, "")
          else
            page.data["edition"] = "community"
            page.data["kong_version"] = parts[0]
            page.data["kong_versions"] = ceVersions
            page.data["kong_latest"] = latestVersion
            page.data["nav_items"] = site.data['docs_nav_' + parts[0].gsub(/\./, '')]
            createAliases(page, '', 0, parts, latestVersion["release"])
            doc_slug = parts[1..-1].join("/").sub(/\.(md)$/, "").sub(/\/?index$/, "")
          end

          # create page's version history
          page.data["version_slugs"] = createVersionHistory(doc_slug, parts[0] == 'enterprise' ? eeVersions : ceVersions, docs_version_history[doc_slug])

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

    def createVersionHistory(slug, all_versions, doc_history)
      timeline = doc_history && doc_history["timeline"]
      is_alias = doc_history["aliases"].include?(slug) unless doc_history.nil? || doc_history["aliases"].nil?
      canonical_slug = is_alias ? doc_history["slug"] : slug
      previous = canonical_slug
      history = {}

      for version in all_versions.reverse
        # get override value if present in page timeline
        slug_override = timeline && timeline[version["release"]]

        if slug_override.nil?
          # no override provided, assume this version uses unchanged article slug
          history[version["release"]] = previous
        elsif slug_override == "PAGE_CREATED"
          # article was created in this version, set all version slugs below this to nil
          history[version["release"]] = previous
          previous = nil
        elsif slug_override == "PAGE_DELETED"
          # article was deleted in this version, start from scratch; nullify previous history
          history = {} if previous == canonical_slug
        else
          # use provided override value
          history[version["release"]] = previous = slug_override
        end
      end

      return history
    end
  end
end
