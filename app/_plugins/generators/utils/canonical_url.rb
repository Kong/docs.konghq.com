# frozen_string_literal: true

module Utils
  class CanonicalUrl
    def self.generate(url)
      return url if url.end_with?('/')

      url.concat('/')
    end
  end
end
