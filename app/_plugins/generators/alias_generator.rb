# frozen_string_literal: true

require 'yaml'
# Alias Generator for Posts using Netlify _redirects
#
# Generates redirect pages for posts with aliases set in the YAML Front Matter.
#
# Place the full path of the alias (place to redirect from) inside the
# destination post's YAML Front Matter. One or more aliases may be given.
#
# Example Post Configuration:
#
#   ---
#     layout: post
#     title: "How I Keep Limited Pressing Running"
#     alias: /post/6301645915/how-i-keep-limited-pressing-running/index.html
#   ---
#
# Example Post Configuration:
#
#   ---
#     layout: post
#     title: "How I Keep Limited Pressing Running"
#     alias: [/first-alias/index.html, /second-alias/index.html]
#   ---
#
# Author: Michael Heap
# Site: http://michaelheap.com

module Jekyll
  class AliasGenerator < Generator
    priority :lowest

    def generate(site)
      @site = site

      # Read existing _redirects file
      redirects = existing_redirects

      # Generate redirects from moved_urls
      redirects.concat(moved_aliases)

      # Generate redirect_to from frontmatter redirects
      redirects.concat(frontmatter_aliases)

      # Read existing _common_redirects file from Kuma
      redirects.concat(kuma_redirects)

      # Redirect sitemap in docs.konghq.com, jp site has an entry in robots.txt
      if site.config['locale'] == I18n.default_locale.to_s
        redirects.push(['/sitemap.xml', '/sitemap-index/default.xml'].join("\t"))
      end

      # Write out a _redirects file
      site.pages << build_page(redirects)
    end

    private

    def build_page(redirects)
      page = PageWithoutAFile.new(@site, __dir__, '', '_redirects')
      page.data['layout'] = nil
      page.content = redirects.join("\n")
      page
    end

    def frontmatter_aliases
      @site.pages.map do |page|
        alias_paths = page.data.fetch('alias', []).compact.flatten

        alias_paths.map do |alias_path|
          if page.data['permalink']
            # Pages with a permalink set can have a redirect added directly
            [alias_path, page.data['permalink']].join("\t")
          else
            # Pages where we replace /latest/ with the latest release version
            [alias_path, page.url].join("\t")
          end
        end
      end.flatten.compact
    end

    def moved_aliases
      @moved_aliases ||= moved_pages.map do |redirect|
        redirect.join("\t").gsub('/VERSION/', '/latest/')
      end
    end

    def moved_pages
      @moved_pages ||= ::Utils::MovedPages.pages(@site)
    end

    def existing_redirects
      @existing_redirects ||= File.readlines(
        File.join(@site.source, '_redirects'),
        chomp: true
      )
    end

    def kuma_redirects
      @kuma_redirects ||= File.readlines(
        File.join(@site.source, '_src/.repos/kuma/app/_common_redirects'),
        chomp: true
      ).map { |redirect| redirect.gsub('/docs/', '/mesh/') }
    end
  end
end
