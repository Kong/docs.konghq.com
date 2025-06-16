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

    def existing_redirects
      @existing_redirects ||= File.readlines(
        File.join(@site.source, '_redirects'),
        chomp: true
      )
    end
  end
end
