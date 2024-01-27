# frozen_string_literal: true

module Utils
  class Version
    def self.to_version(input)
      Gem::Version.new(input.to_s.gsub(/\.x$/, '.0'))
    end

    def self.to_release(input)
      input.split('.').take(2).push('x').join('.')
    end

    def self.to_semver(input)
      input.gsub('-x', '.x').gsub(/\.x/, '.0')
    end
  end
end
