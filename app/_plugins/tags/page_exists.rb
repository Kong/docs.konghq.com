# frozen_string_literal: true

module Jekyll
  class PageExistsTag < Liquid::Tag
    def initialize(tag_name, path, tokens)
      super
      @path = path
    end

    def render(context)
      url = Liquid::Template.parse(@path).render context
      url = url.strip

      # Loop through all registered pages, and return if there
      # is a page with the URL that we're expecting
      context.registers[:site].data['pages_urls'].include?(url)
    end
  end
end

Liquid::Template.register_tag('page_exists', Jekyll::PageExistsTag)
