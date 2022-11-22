# frozen_string_literal: true

module PluginSingleSource
  class KongVersions
    GATEWAY_VERSIONS = %w[gateway gateway-oss enterprise].freeze

    def self.gateway
      new.gateway
    end

    def self.to_semver(version)
      version.gsub('-x', '.x').gsub(/\.x/, '.0')
    end

    def gateway
      @gateway ||= versions
                   .select { |v| GATEWAY_VERSIONS.include?(v['edition']) }
                   .map { |v| v['release'].gsub('-x', '.x') }
                   .uniq
    end

    def versions
      @versions ||= SafeYAML.load(File.read('app/_data/kong_versions.yml'))
    end
  end
end
