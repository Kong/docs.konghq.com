Jekyll::Hooks.register :site, :post_write do |site|
  latest = site.data['latest_version']
  File.write "#{site.dest}/latest_version", latest['version']
end 