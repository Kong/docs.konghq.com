# frozen_string_literal: true

module KumaToKongMesh
  class Generator < Jekyll::Generator
    priority :lowest
    def generate(site)
      site.pages.each do |page|
        next unless page.data['title']

        page.data['title'] = page.data['title'].gsub('Kuma', 'Kong Mesh')
      end
    end
  end
end
