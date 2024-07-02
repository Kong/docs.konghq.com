# frozen_string_literal: true

module Sitemap
  class Page < Jekyll::Page
    def initialize(site, basename, domain) # rubocop:disable Lint/MissingSuper, Metrics/MethodLength
      @site = site
      @base = site.source
      @dir = '/sitemap-index/'
      @basename = basename
      @ext = '.xml'

      @content = ''

      @data = {
        'layout' => 'sitemap',
        'permalink' => "#{@dir}#{@basename}#{@ext}",
        'domain' => domain,
        'no_version' => true
      }
    end
  end

  class Generator < Jekyll::Generator
    priority :low

    def generate(site)
      return if ENV['JEKYLL_ENV'] == 'development'
      return if site.config['locale'] != I18n.default_locale.to_s

      @site = site

      index = SEO::Index.new(@site)
      index.generate
      @site.data['sitemap_pages'] = SEO::Sitemap.generate(index)

      @site.pages.concat(generate_sitemaps)
    end

    def generate_sitemaps
      [
        ::Sitemap::Page.new(@site, 'default', @site.config.dig('links', 'locales', 'en')),
        ::Sitemap::Page.new(@site, 'jp', @site.config.dig('links', 'locales', 'ja'))
      ]
    end
  end
end
