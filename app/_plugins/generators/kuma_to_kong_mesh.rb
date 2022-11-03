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
        # Links can end with a " (html) or ) (markdown)
        page.content = page.content.gsub(%r{([("]/.*(?=kuma))kuma([^\s]*)([)"])}, '\1kong-mesh\2\3')
        page.content = page.content.gsub('kong-mesh.io', 'kuma.io')

        # Replace the base url from Kuma
        page.content = page.content.gsub(%r{/docs/{{ page.version }}}, '/mesh/{{ page.kong_version }}')
      end
    end
  end
end
