# frozen_string_literal: true

module Jekyll
  class Versions < Jekyll::Generator # rubocop:disable Metrics/ClassLength
    priority :high

    def generate(site) # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
      ce_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'gateway-oss'
      end

      ee_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'enterprise'
      end

      gsg_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'getting-started-guide'
      end

      deck_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'deck'
      end

      mesh_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'mesh'
      end

      konnect_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'konnect'
      end

      konnect_platform_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'konnect-platform'
      end

      kic_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'kubernetes-ingress-controller'
      end

      contributing_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'contributing'
      end

      gateway_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'gateway'
      end

      site.data['kong_versions_ce'] = ce_versions
      site.data['kong_versions_ee'] = ee_versions
      site.data['kong_versions_gsg'] = gsg_versions
      site.data['kong_versions_deck'] = deck_versions
      site.data['kong_versions_mesh'] = mesh_versions
      site.data['kong_versions_konnect'] = konnect_versions
      site.data['kong_versions_konnect_platform'] = konnect_platform_versions
      site.data['kong_versions_kic'] = kic_versions
      site.data['kong_versions_contributing'] = contributing_versions
      site.data['kong_versions_gateway'] = gateway_versions

      # Retrieve the latest version and put it in `site.data.kong_latest.version`

      # There are no "latest" entries for ce_versions, ee_versions, or gsg_versions,
      # because these docs no longer need a /latest/ URL. Any
      # /enterprise/latest/, /gateway-oss/latest, or
      # /getting-stared-guide/latest/ URL should redirect to /gateway/latest.

      latest_version_deck = deck_versions.last
      latest_version_mesh = mesh_versions.last
      latest_version_kic = kic_versions.last
      latest_version_gateway = gateway_versions.last

      site.data['kong_latest_mesh'] = latest_version_mesh
      site.data['kong_latest_KIC'] = latest_version_kic
      site.data['kong_latest_deck'] = latest_version_deck
      site.data['kong_latest_gateway'] = latest_version_gateway

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page| # rubocop:disable Metrics/BlockLength
        path = page.path

        # Remove the generated prefix if it's present
        # It's in the format GENERATED:nav=nav/product_1.2.x:src=src/path/here:/output/path
        if path.start_with?('GENERATED:')
          path = path.split(':')
          path.shift(3)
          path = path.join(':')
        end

        parts = Pathname(path).each_filename.to_a

        page.data['has_version'] = true
        # Only apply those rules to documentation pages
        is_product = %w[
          enterprise
          getting-started-guide
          mesh
          deck
          contributing
          konnect
          konnect-platform
          kubernetes-ingress-controller
          gateway
          gateway-oss
        ].any? { |p| parts[0] == p }
        has_version = parts[0].match(/[0-3]\.[0-9]{1,2}(\..*)?$/)
        next unless is_product || has_version

        case parts[0]
        when 'enterprise'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = ee_versions
          page.data['nav_items'] = site.data["docs_nav_ee_#{parts[1].gsub(/\./, '')}"]
          create_aliases(page, '/enterprise', 1, parts, 'release')
        when 'getting-started-guide'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = gsg_versions
          page.data['nav_items'] = site.data["docs_nav_gsg_#{parts[1].gsub(/\./, '')}"]
          create_aliases(page, '/getting-started-guide', 1, parts, 'release')
        when 'mesh'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = mesh_versions
          page.data['kong_latest'] = latest_version_mesh
          page.data['nav_items'] = site.data["docs_nav_mesh_#{parts[1].gsub(/\./, '')}"]
          create_aliases(page, '/mesh', 1, parts, latest_version_mesh['release'])
        when 'konnect'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = konnect_versions
          page.data['nav_items'] = site.data['docs_nav_konnect']
          create_aliases(page, '/konnect', 1, parts, 'release')
        when 'konnect-platform'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = konnect_platform_versions
          page.data['nav_items'] = site.data['docs_nav_konnect_platform']
          create_aliases(page, '/konnect-platform', 1, parts, 'release')
        when 'kubernetes-ingress-controller'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = kic_versions
          page.data['kong_latest'] = latest_version_kic
          page.data['nav_items'] = site.data["docs_nav_kic_#{parts[1].gsub(/\./, '')}"]
          create_aliases(page, '/kubernetes-ingress-controller', 1, parts, latest_version_kic['release'])
        when 'deck'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = deck_versions
          page.data['kong_latest'] = latest_version_deck
          page.data['nav_items'] = site.data["docs_nav_deck_#{parts[1].gsub(/\./, '')}"]
          create_aliases(page, '/deck', 1, parts, latest_version_deck['release'])
        when 'gateway'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = gateway_versions
          page.data['kong_latest'] = latest_version_gateway
          page.data['nav_items'] = site.data["docs_nav_gateway_#{parts[1].gsub(/\./, '')}"]
          create_aliases(page, '/gateway', 1, parts, latest_version_gateway['release'])
        when 'contributing'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = contributing_versions
          page.data['nav_items'] = site.data['docs_nav_contributing']
          create_aliases(page, '/contributing', 1, parts, 'release')
        when 'gateway-oss'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1]
          page.data['kong_versions'] = ce_versions
          page.data['nav_items'] = site.data["docs_nav_ce_#{parts[1].gsub(/\./, '')}"]
          create_aliases(page, '/gateway-oss', 1, parts, 'release')
        end

        # Clean up nav_items for generated pages as there's an
        # additional level of nesting
        page.data['nav_items'] = page.data['nav_items']['items'] if page.data['nav_items'].is_a?(Hash)

        # Helpful boolean in templates. If version has .md, then it is not versioned
        page.data['has_version'] = false if page.data['kong_version'].include? '.md'
      end
    end

    def create_aliases(page, _url_path, offset, parts, latest_release)
      release_path = parts[0 + offset]
      template_name = parts[1 + offset]

      return unless release_path == latest_release

      # template_name is nil if using single source generation and it's the index page
      if template_name == 'index.md' || template_name.nil?
        # This will be handled by latest_version_generator later
      elsif /index\.(md|html)/.match(parts.last)
        # all other nested index pages
        page.data['alias'] = page.url.sub(/index/, '')
      end
    end
  end
end
