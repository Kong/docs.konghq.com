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
  end
end
