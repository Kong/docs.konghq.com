# frozen_string_literal: true

require'yaml'

REDIRECTS = YAML.load_file('./redirects.yaml')

def dev_site_url_for(page)
  dev_site_url = page.site.config.dig('links', 'dev_site')
  page_url = page.data['canonical_url'] || page.url
  entry = REDIRECTS.detect { |u| u['docs_url'] == page_url }
  url = entry && entry['dev_site_url'] || '/'

  "#{dev_site_url}#{url}"
end


Jekyll::Hooks.register :site, :pre_render do |site|
  site.pages.each do |page|
    page.data['dev_site_link'] = dev_site_url_for(page)
  end
end
