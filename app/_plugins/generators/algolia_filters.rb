# frozen_string_literal: true

module Jekyll
  class AlgoliaFilters < Jekyll::Generator
    priority :low

    def generate(site)
      site.pages.each do |page|
        Jekyll::Algolia::Base.make_for(page).generate_filters!
      end
    end
  end
end
