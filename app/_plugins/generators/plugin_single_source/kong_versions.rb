# frozen_string_literal: true

module PluginSingleSource
  class KongVersions
    GATEWAY_VERSIONS = %w[gateway].freeze

    def self.gateway(site)
      new(site).gateway
    end

    def self.to_semver(version)
      version.gsub('-x', '.x').gsub(/\.x/, '.0')
    end

    attr_reader :site

    def initialize(site)
      @site = site
    end

    def gateway
      @gateway ||= versions
                   .select { |v| GATEWAY_VERSIONS.include?(v['edition']) }
                   .map { |v| v['release'].gsub('-x', '.x') }
                   .uniq
    end

    def versions
      @versions ||= SafeYAML.load(
        File.read(File.join(site.source, '_data/kong_versions.yml'))
      )
    end
  end
end
