# Language: Ruby, Level: Level 3
# frozen_string_literal: true

module Jekyll
  class Versions < Jekyll::Generator
    priority :high

    def generate(site) # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
      deck = Jekyll::GeneratorSingleSource::Product::Edition.new(edition: 'deck', site:)
      mesh = Jekyll::GeneratorSingleSource::Product::Edition.new(edition: 'mesh', site:)
      kic = Jekyll::GeneratorSingleSource::Product::Edition.new(edition: 'kubernetes-ingress-controller', site:)
      gateway = Jekyll::GeneratorSingleSource::Product::Edition.new(edition: 'gateway', site:)
      gateway_operator = Jekyll::GeneratorSingleSource::Product::Edition.new(edition: 'gateway-operator', site:)
      konnect = Jekyll::GeneratorSingleSource::Product::Edition.new(edition: 'konnect', site:)
      contributing = Jekyll::GeneratorSingleSource::Product::Edition.new(edition: 'contributing', site:)

      site.data['kong_versions_deck'] = deck.releases.map(&:to_h)
      site.data['kong_versions_mesh'] = mesh.releases.map(&:to_h)
      site.data['kong_versions_konnect'] = konnect.releases.map(&:to_h)
      site.data['kong_versions_kic'] = kic.releases.map(&:to_h)
      site.data['kong_versions_contributing'] = contributing.releases.map(&:to_h)
      site.data['kong_versions_gateway'] = gateway.releases.map(&:to_h)
      site.data['kong_versions_kgo'] = gateway_operator.releases.map(&:to_h)

      # Retrieve the latest version and put it in `site.data.kong_latest.version`
      site.data['kong_latest_mesh'] = mesh.latest_release.to_h
      site.data['kong_latest_KIC'] = kic.latest_release.to_h
      site.data['kong_latest_deck'] = deck.latest_release.to_h
      site.data['kong_latest_gateway'] = gateway.latest_release.to_h
      site.data['kong_latest_kgo'] = gateway_operator.latest_release.to_h

      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages
      site.pages.each do |page|
        Jekyll::Pages::VersionData.new(site:, page:).process!
        Jekyll::Pages::NavItemsData.new(site:, page:).process!
      end
    end
  end
end
