# frozen_string_literal: true

Jekyll::Hooks.register :site, :post_write do |site|
  if Jekyll::Commands::Doctor.conflicting_urls(site)
    raise "Conflict: Two or more pages have the same output path. Check Jekyll's logs for more info."
  end
end
