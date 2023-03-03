# frozen_string_literal: true

module Sitemap
  class Generator < Jekyll::Generator
    priority :low

    def generate(site)
      index = SEO::Index.new(site)
      index.generate
      site.data['sitemap_pages'] = SEO::Sitemap.generate(index)
    end
  end
end
