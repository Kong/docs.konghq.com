# frozen_string_literal: true

module Utils
  class Version
    def self.to_version(input)
      # Latest should always be the top value
      return Gem::Version.new('9999.9.9') if input == 'latest'

      Gem::Version.new(input.gsub(/\.x$/, '.0'))
    end
  end
end
