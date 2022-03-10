sharedPages = {};

# Build up a list of all shared pages
Jekyll::Hooks.register([:pages], :post_init) do |page|
  next unless page.path.include? "/shared/"

  # We don't want to publish shared files
  page.data["published"] = false
  sharedPages[page.path] = page
end

# Rewrite the pages with a ref to point to the other page
Jekyll::Hooks.register([:pages], :pre_render) do |post|
  next unless post.data['ref']

  # Work out which page we're referencing
  parts = post.data['ref'].split(":")
  product = parts[0]
  path = "#{parts[1]}.md"

  lookupKey = "#{product}/shared/#{path}"
  raise "Incorrect ref '#{post.data['ref']}' (#{lookupKey})" unless sharedPages[lookupKey]

  target = sharedPages[lookupKey];

  # Overwrite the data + content
  post.data = target.data;
  if post.data["override"]
    dataOverride = post.data["override"].clone
    dataOverride.each do |k,v|
      post.data[k] = v
    end
  end
  post.content = target.content
end
