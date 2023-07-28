# frozen_string_literal: true

Jekyll::Hooks.register :site, :post_write do |site|
  Jekyll.logger.info "Total number of pages generated: #{site.pages.size}"
end
