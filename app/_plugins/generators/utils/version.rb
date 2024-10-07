# frozen_string_literal: true

module Utils
  class Version
    def self.to_version(input)
      Gem::Version.new(input.to_s.gsub(/\.x$/, '.0'))
    end

    def self.to_release(input)
      input.split('.').tap(&:pop).push('x').join('.')
    end

    def self.to_semver(input)
      input.gsub('-x', '.x').gsub('.x', '.0')
    end

    def self.in_range?(input, min: nil, max: nil)
      version = Gem::Version.new(input)

      lower_limit = min ? ">= #{min}" : nil
      upper_limit = max ? "<= #{max}" : nil

      Gem::Requirement
        .new([lower_limit, upper_limit])
        .satisfied_by?(version)
    end

    def self.versions_for(release_hash)
      if release_hash.has_key?('version')
        { 'default' => release_hash['version'] }
      else
        versions_without_suffix(release_hash)
      end
    end

    def self.versions_without_suffix(release_hash)
      release_hash.each_with_object({}) do |(k, v), h|
        if k.end_with?('-version')
          h[k.sub('-version', '')] = v
        end
      end
    end
  end
end
