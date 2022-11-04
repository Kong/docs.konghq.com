# Language: Ruby, Level: Level 3
# frozen_string_literal: true

module KumaToKongMesh
  class Generator < Jekyll::Generator
    priority :lowest
    def generate(site) # rubocop:disable Metrics/AbcSize
      site.pages.each do |page|
        next unless page.data['path']&.include?('docs_nav_mesh')

        page.data['title'] = page.data['title'].gsub('Kuma', 'Kong Mesh')

        # Replace kuma with kong-mesh in links
        # Links can be wrapped with " (html) or ( and ) (markdown)
        page.content = page.content.gsub(%r{([("]/.*)kuma(?!(?:-cp|-dp|ctl))([^\s]*)([)"])}, '\1kong-mesh\2\3')
        page.content = page.content.gsub('kong-mesh.io', 'kuma.io')

        exact_link_transforms = {
          '/install/?' => '/mesh/{{ page.kong_version }}/install/',
          '/enterprise/?' => '/mesh/{{ page.kong_version }}/',
          '/community/?' => 'https://konghq.com/community'
        }
        exact_link_transforms.each do |k,v|
          page.content = page.content.gsub(%r{([("])#{k}([)"])}, "\\1#{v}\\2")
        end

        # Replace the base url from Kuma
        page.content = page.content.gsub(%r{/docs/{{\s*page.version\s*}}}, '/mesh/{{ page.kong_version }}')
      end
    end
  end
end
