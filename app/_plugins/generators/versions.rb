# Language: Ruby, Level: Level 3
# frozen_string_literal: true

module Jekyll
  class Versions < Jekyll::Generator # rubocop:disable Metrics/ClassLength
    priority :high

    def generate(site) # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
      deck_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'deck'
      end

      mesh_versions = site.data['kong_versions'].select do |elem|
        is_ignored = (site.config['mesh_disabled_versions'] || []).include?(elem['release'])
        elem['edition'] && elem['edition'] == 'mesh' && !is_ignored
      end

      konnect_versions = site.data['kong_versions'].select do |elem|
        elem['edition'] && elem['edition'] == 'konnect'
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

      site.data['kong_versions_deck'] = deck_versions
      site.data['kong_versions_mesh'] = mesh_versions
      site.data['kong_versions_konnect'] = konnect_versions
      site.data['kong_versions_kic'] = kic_versions
      site.data['kong_versions_contributing'] = contributing_versions
      site.data['kong_versions_gateway'] = gateway_versions

      # Retrieve the latest version and put it in `site.data.kong_latest.version`

      latest_version_deck = deck_versions.last
      latest_version_mesh = mesh_versions.find { |x| x['latest'] }
      latest_version_kic = kic_versions.last
      latest_version_gateway = gateway_versions.last

      site.data['kong_latest_mesh'] = latest_version_mesh
      site.data['kong_latest_KIC'] = latest_version_kic
      site.data['kong_latest_deck'] = latest_version_deck
      site.data['kong_latest_gateway'] = latest_version_gateway

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page| # rubocop:disable Metrics/BlockLength
        # Remove the generated prefix if it's present
        path = if page.relative_path.start_with?('_src')
                 page.dir.delete_prefix('/')
               else
                 page.path
               end

        parts = Pathname(path).each_filename.to_a

        page.data['has_version'] = false

        # Only apply those rules to documentation pages
        is_product = %w[
          mesh
          deck
          contributing
          konnect
          kubernetes-ingress-controller
          gateway
        ].any? { |p| parts[0] == p }

        next unless is_product

        has_version = Gem::Version.correct?(parts[1]) || parts[1] == 'pre-1.7'

        page.data['has_version'] = true if has_version

        case parts[0]
        when 'mesh'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1] if has_version
          page.data['kong_versions'] = mesh_versions
          page.data['kong_latest'] = latest_version_mesh
          page.data['nav_items'] ||= site.data["docs_nav_mesh_#{parts[1].gsub(/\./, '')}"]
          version_data = mesh_versions.detect { |v| v['release'] == parts[1] }
          if version_data
            page.data['version'] = version_data['version']
            page.data['release'] = version_data['release']
            page.data['version_data'] = version_data
          end
        when 'konnect'
          page.data['edition'] = parts[0]
          page.data['kong_versions'] = konnect_versions
          page.data['nav_items'] = site.data['docs_nav_konnect']
        when 'kubernetes-ingress-controller'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1] if has_version
          page.data['kong_versions'] = kic_versions
          page.data['kong_latest'] = latest_version_kic
          page.data['nav_items'] = site.data["docs_nav_kic_#{parts[1].gsub(/\./, '')}"]
        when 'deck'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1] if has_version
          page.data['kong_versions'] = deck_versions
          page.data['kong_latest'] = latest_version_deck
          page.data['nav_items'] = site.data["docs_nav_deck_#{parts[1].gsub(/\./, '')}"]
        when 'gateway'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1] if has_version
          page.data['kong_versions'] = gateway_versions
          page.data['kong_latest'] = latest_version_gateway
          page.data['nav_items'] = site.data["docs_nav_gateway_#{parts[1].gsub(/\./, '')}"]
        when 'contributing'
          page.data['edition'] = parts[0]
          page.data['kong_version'] = parts[1] if has_version
          page.data['kong_versions'] = contributing_versions
          page.data['nav_items'] = site.data['docs_nav_contributing']
        end

        # Add additional variables that are available in src pages
        # to pages in app
        if !page.data['release'] && page.data['kong_version']
          # Skip if the page does not have a version
          next unless Gem::Version.correct?(page.data['kong_version']) || page.data['kong_version'] == 'pre-1.7'

          current = page.data['kong_versions'].find do |elem|
            elem['release'] == page.data['kong_version']
          end

          raise "Could not find #{page.data['edition']} #{page.data['kong_version']}" unless current

          page.data['release'] = current['release']
          page.data['version'] = current['version']
          page.data['versions'] = {
            'ce' => current['ce-version'],
            'ee' => current['ee-version']
          }
        end

        # Add a `major_minor_version` property which is used for cloudsmith install pages
        page.data['major_minor_version'] = page.data['release'].gsub('.x', '').gsub('.', '') if page.data['release']

        # Clean up nav_items for generated pages as there's an
        # additional level of nesting
        page.data['nav_items'] = page.data['nav_items']['items'] if page.data['nav_items'].is_a?(Hash)
        page.data['sidenav'] = DocsSingleSource::Sidenav.new(page).generate
      end
    end
  end
end
