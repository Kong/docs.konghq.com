# frozen_string_literal: true

module Robots
  class Generator < Jekyll::Generator
    priority :low

    def generate(site)
      @site = site
      @site.data['robots'] = {}
      @site.data['robots']['sitemaps'] = sitemap_entries(site)
    end

    def sitemap_entries(site)
      if site.config['locale'] == I18n.default_locale.to_s
        [
          "#{site.config.dig('links', 'web')}/sitemap-index/default.xml",
          "#{site.config.dig('links', 'web')}/sitemap-index/jp.xml"
        ]
      else
        ["#{site.config.dig('links', 'web')}/sitemap-index/jp.xml"]
      end
    end
  end
end
