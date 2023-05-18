# frozen_string_literal: true

module Jekyll
  # Add a way to change the page URL
  class Page
    attr_writer :url
  end
end

module LatestVersion
  class Generator < Jekyll::Generator
    priority :medium

    PRODUCTS_WITH_LATEST = {
      'gateway' => 'gateway',
      'mesh' => 'mesh',
      'deck' => 'deck',
      'kubernetes-ingress-controller' => 'KIC'
    }.freeze

    def generate(site)
      @site = site

      site.pages.each do |page|
        # If it has a permalink it's _probably_ an index page e.g. /gateway/
        # so we should not generate a /latest/ URL as it's already evergreen
        next if page.data['is_latest'] || page.data['permalink']

        next unless generate_latest?(page)

        # Otherwise, let's generate a /latest/ URL too
        site.pages << build_duplicate_page(page)
      end
    end

    private

    def build_duplicate_page(page)
      product_name, release_path = page_path(page).first(2)

      DuplicatePage.new(
        @site,
        page.url.gsub(release_path, 'latest'),
        page,
        page_index["#{product_name}/#{release_path}/"],
        remove_generated_prefix(page)
      )
    end

    def generate_latest?(page)
      product_name_from_path, release_path = page_path(page).first(2)
      product_name, product = PRODUCTS_WITH_LATEST.detect do |k, _|
        k == product_name_from_path
      end

      product_name &&
        release_path == @site.data["kong_latest_#{product}"]['release']
    end

    def page_index
      # XXX: this isn't being set on any of the pages
      @page_index ||= @site.config['defaults'].to_h do |s|
        [s['scope']['path'], s['values']['version-index']]
      end
    end

    def page_path(page)
      Pathname(remove_generated_prefix(page)).each_filename.to_a
    end

    def remove_generated_prefix(page)
      if page.relative_path.start_with?('_src')
        page.dir.delete_prefix('/')
      else
        page.path
      end
    end
  end

  class DuplicatePage < ::Jekyll::Page
    def initialize(site, url, original_page, page_index, path) # rubocop:disable Lint/MissingSuper, Metrics/MethodLength, Metrics/AbcSize
      @site = site
      @base = site.source
      @content = original_page.content
      @dir = url
      @name = 'index.md'

      process(@name)

      @data = original_page.data.clone
      @data['is_latest'] = true
      @data['version-index'] = page_index
      @data['edit_link'] = "app/#{path}" unless @data['edit_link']
      @data['alias'] = [@dir.sub('latest/', '')] if @dir.end_with?('/latest/')

      @relative_path = original_page.relative_path
      @data['sidenav'] = DocsSingleSource::Sidenav.new(self).generate
    end
  end
end
