# frozen_string_literal: true

Jekyll::Hooks.register :site, :pre_render do |site|
  site.data['pages_urls'] = Set.new

  site.pages.each do |page|
    site.data['pages_urls'] << page.url
  end
end
