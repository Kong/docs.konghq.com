# Jekyll filter to make text title-cased
# It takes into account words in all caps/acronyms

# "UDP Login" | titlelize => "UDP login"
# "HMAC authentication" | titleize => "HMAC authentication"
# "HMAC Authentication and UDP Login" => "HMAC authentication and UDP login"

module Jekyll
  module TitleizeFilter
    extend self
    def titleize(text)
      tokens = text.split
      tokens = tokens.map.with_index do |t, i|
        if t === t.upcase
          t
        elsif i === 0
          t.capitalize
        else
          t.downcase
        end
      end
      tokens.join(" ")
    end
  end
end

Liquid::Template.register_filter(Jekyll::TitleizeFilter)
