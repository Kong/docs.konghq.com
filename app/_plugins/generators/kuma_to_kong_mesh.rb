# Language: Ruby, Level: Level 3
# frozen_string_literal: true

module KumaToKongMesh
  class Generator < Jekyll::Generator
    priority :lowest

    EXACT_LINKS_TRANSFORMS = {
      '/install/?' => '/mesh/{{ page.release }}/install/',
      '/enterprise/?' => '/mesh/{{ page.release }}/',
      '/community/?' => 'https://konghq.com/community'
    }.freeze

    def generate(site)
      site.pages.each do |page|
        next unless page.path.start_with?('_src/.repos/kuma')

        replace_title(page)
        replace_kuma_with_kong_mesh_in_links(page)
        replace_exact_links(page)
        replace_kuma_base_url(page)
        replace_edit_url(page)
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
                     # only consider urls that start with / or #
                     .gsub(%r{([("][/#](?!assets/).*)kuma(?!(?:-cp|-dp|ctl))([^\s]*)([)"])}) do |s|
                       # replace kuma to kong-mesh as many times as it occurs but do not replace
                       # kuma.io or kumaio (These are annotations and should remain unchanged)
                       s.gsub(/kuma(?!(\.?io))/, 'kong-mesh')
                     end
    end

    def replace_exact_links(page)
      EXACT_LINKS_TRANSFORMS.each do |k, v|
        page.content = page.content.gsub(/([("])#{k}([)"])/, "\\1#{v}\\2")
      end
    end

    def replace_kuma_base_url(page)
      page.content = page
                     .content
                     .gsub(%r{/docs/{{\s*page.version\s*}}}, '/mesh/{{ page.release }}')
    end

    def replace_edit_url(page)
      return unless page.data['edit_link']

      path = page.data['edit_link'].gsub('_src/.repos/kuma/', '')
      page.data['edit_link'] = "https://github.com/kumahq/kuma-website/edit/master/#{path}"
    end
  end
end
