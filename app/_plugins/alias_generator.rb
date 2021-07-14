# Alias Generator for Posts.
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
# Author: Thomas Mango
# Site: http://thomasmango.com
# Plugin Source: http://github.com/tsmango/jekyll_alias_generator
# Site Source: http://github.com/tsmango/tsmango.github.com
# Plugin License: MIT

module Jekyll

  class AliasGenerator < Generator

    def generate(site)
      @site = site
      @generated = {}

      process_posts
      process_pages
    end

    def process_posts
      @site.posts.docs.each do |post|
        generate_aliases(post.url, post.data['alias'])
      end
    end

    def process_pages
      @site.pages.each do |page|
        generate_aliases(page.destination('').gsub(/index\.(html|htm)$/, ''), page)
      end
    end

    def generate_aliases(destination_path, page)
      aliases = page.data['alias']
      alias_paths ||= Array.new
      alias_paths << aliases
      alias_paths.compact!

      alias_paths.flatten.each do |alias_path|
        alias_path = alias_path.to_s

        alias_dir = File.extname(alias_path).empty? ? alias_path : File.dirname(alias_path)
        alias_file = File.extname(alias_path).empty? ? "index.html" : File.basename(alias_path)

        fs_path_to_dir = File.join(@site.dest, alias_dir)
        alias_index_path = File.join(alias_dir, alias_file)

        FileUtils.mkdir_p(fs_path_to_dir)

        File.open(File.join(fs_path_to_dir, alias_file), "w") do |file|
          file.write(alias_template(page, destination_path))
        end

        (alias_index_path.split("/").size).times do |sections|
          target = alias_index_path.split("/")[1, sections + 1].join("/")
          target_version = page.data["kong_versions"].last["release"]

          # We only want to generate each alias once

          # This code snippet works by generating a redirect for every segment of a URL
          # e.g. enterprise/2.4.x/developer-portal/using-the-editor/ will generate:
          # enterprise/latest => enterprise/2.4.x
          # enterprise/latest/developer-portal => enterprise/2.4.x/developer-portal
          # enterprise/latest/developer-portal/using-the-editor => enterprise/2.4.x/developer-portal/using-the-editor

          # This works until you have two pages with a common base URL such as:
          # enterprise/2.4.x/developer-portal/working-with-templates/index.html
          # enterprise/2.4.x/developer-portal/using-the-editor/

          # In this instance, enterprise/2.4.x/developer-portal will be generated twice
          # and jekyll will complain with the following error:
          # Conflict: The following destination is shared by multiple files

          # To resolve this, we keep track of all URLs we generate a redirect for and skip
          # the generation if the version they're pointing to are the same

          # If two redirects point to different versions, we raise an error as this
          # should never happen

          # If the versions match, skip generation
          next if @generated[target] && target_version == @generated[target]

          # Otherwise error if the two versions are different
          raise "Two pages point to different versions: #{target} (#{target_version} and #{@generated[target]})" if @generated[target]

          @generated[target] = target_version
          @site.static_files << Jekyll::AliasFile.new(@site, @site.dest, target, "")
        end
      end
    end

    def alias_template(page, destination_path)
      <<-EOF
<!DOCTYPE html>
<html>
  <head>
    <link rel="canonical" href="#{destination_path}"/>
    <meta http-equiv="content-type" content="text/html; charset=utf-8" />
    <noscript><meta http-equiv="refresh" content="0;url=#{destination_path}" /></noscript>
  </head>
  <body>
  Redirecting...
  <script>
    var latest = '#{page.data["kong_versions"].last["release"]}';
    var destination = window.location.pathname.replace(/latest/i, latest);
    var urlsplit = window.location.href.split('latest');

    if ( urlsplit && urlsplit.length > 0 && (urlsplit[1] === '/' || typeof urlsplit[1] === 'undefined') ) {
      window.location.href = '#{page.data["permalink"]}';
    } else {
      window.location.href = destination + (window.location.hash || '');
    }

  </script>
  </body>
</html>
      EOF
    end
  end

  class AliasFile < StaticFile
    require 'set'

    def destination(dest)
      File.join(dest, @dir)
    end

    def modified?
      return false
    end

    def write(dest)
      return true
    end
  end
end
