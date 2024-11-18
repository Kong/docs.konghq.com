# Language: Ruby, Level: Level 3
# frozen_string_literal: true

module Jekyll
  class Versions < Jekyll::Generator
    priority :high

    def generate(site)
      # Add a `version` property to every versioned page
      # Also create aliases under /latest/ for all x.x.x doc pages

      site.pages.each do |page|
        Jekyll::Pages::StaticPageMissingTranslation.new(site:, page:).process!
        Jekyll::Pages::VersionData.new(site:, page:).process!
        Jekyll::Pages::NavItemsData.new(site:, page:).process!
      end
    end
  end
end
