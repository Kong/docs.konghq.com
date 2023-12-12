# frozen_string_literal: true

require 'nokogiri'

module Jekyll
  Jekyll::Hooks.register :pages, :post_render do |page|
    # Only process pages. This prevents _redirects being output with a HTML doctype
    next unless page.is_a?(Jekyll::Page)

    has_changes = false
    doc = ::Nokogiri::HTML(page.output)
    doc.css('a').each do |link|
      href = link.attributes['href']&.value
      next unless href # No href, skip
      next unless href.start_with?('http://') || href.start_with?('https://') # Not an external link, skip

      has_changes = true

      if link.attributes['data-skip-external-links-hook']&.value
        link.remove_attribute('data-skip-external-links-hook')
      else
        link.set_attribute('target', '_blank')
        link.set_attribute('rel', "noopener nofollow noreferrer #{link.attributes['rel']&.value}")
      end
    end

    page.output = doc.to_html if has_changes
  end
end
