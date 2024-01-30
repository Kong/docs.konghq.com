# frozen_string_literal: true

module Utils
  class CanonicalUrl
    def self.generate(url)
      return url if url.end_with?('/')
      return url if url.end_with?('.html') || url.end_with?('.xml')

      # call dup here because #concat
      # modifies the string
      url.dup.concat('/')
    end
  end
end
