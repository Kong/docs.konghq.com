# Language: Ruby, Level: Level 3
# frozen_string_literal: true

module KumaToKongMesh
  class Generator < Jekyll::Generator
    priority :lowest

    EXACT_LINKS_TRANSFORMS = {
      '/install/?' => '/mesh/{{ page.kong_version }}/install/',
      '/enterprise/?' => '/mesh/{{ page.kong_version }}/',
      '/community/?' => 'https://konghq.com/community'
    }.freeze

    def generate(site)
      site.pages.each do |page|
        next unless page.data['path']&.include?('docs_nav_mesh')

        replace_title(page)
        replace_kuma_with_kong_mesh_in_links(page)
        replace_exact_links(page)
        replace_kuma_base_url(page)
      end
    end

    private

    def replace_title(page)
      page.data['title'] = page.data['title'].gsub('Kuma', 'Kong Mesh')
    end

    def replace_kuma_with_kong_mesh_in_links(page)
      # Links can be wrapped with " (html) or ( and ) (markdown)
      page.content = page
                     .content
                     .gsub(%r{([("]/.*)kuma(?!(?:-cp|-dp|ctl))([^\s]*)([)"])}, '\1kong-mesh\2\3')
                     .gsub('kong-mesh.io', 'kuma.io')
    end

    def replace_exact_links(page)
      EXACT_LINKS_TRANSFORMS.each do |k, v|
        page.content = page.content.gsub(/([("])#{k}([)"])/, "\\1#{v}\\2")
      end
    end

    def replace_kuma_base_url(page)
      page.content = page
                     .content
                     .gsub(%r{/docs/{{\s*page.version\s*}}}, '/mesh/{{ page.kong_version }}')
    end
  end
end
