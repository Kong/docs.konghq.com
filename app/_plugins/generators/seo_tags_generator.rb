# frozen_string_literal: true

module SEOTags
  class Generator < Jekyll::Generator
    priority :lowest

    def generate(site)
      site.pages.each do |page|
        SEO::Tags::Title.new(page).process
      end
    end
  end
end
