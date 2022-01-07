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

    def generate(site)
      @redirects = []

      site.pages.each do |page|
        generate_aliases(page.destination('').gsub(/index\.(html|htm)$/, ''), page)
      end

      # Read existing _redirects file
      existing = File.read("#{__dir__}/../_redirects").to_s + "\n"

      # Write out a _redirects file
      page = PageWithoutAFile.new(site, __dir__, '', '_redirects')
      page.content = existing + @redirects.join("\n")
      page.data['layout'] = nil
      site.pages << page
    end

    def generate_aliases(destination_path, page)
      aliases = page.data['alias']
      alias_paths ||= Array.new
      alias_paths << aliases
      alias_paths.compact!
      alias_paths.flatten!

      alias_paths.each do |alias_path|
        alias_path = alias_path.to_s
        if page.data['permalink']
          # Pages with a permalink set can have a redirect added directly
          @redirects.push("#{alias_path}\t#{page.data['permalink']}")
        else
          # Pages where we replace /latest/ with the latest release version
          new_url = alias_path.gsub("latest", page.data["kong_versions"].last["release"])
          @redirects.push("#{alias_path}\t#{new_url}")
        end
      end
    end
  end
end
