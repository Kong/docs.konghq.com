# frozen_string_literal: true

module Utils
  class MovedPages
    def self.pages(site)
      YAML.load_file(File.join(site.source, 'moved_urls.yml'))
    end
  end
end
