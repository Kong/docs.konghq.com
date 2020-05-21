module Jekyll
  class PageExistsTag < Liquid::Tag

    def initialize(tag_name, path, tokens)
      super
      @path = path
    end

    def render(context)
      url = Liquid::Template.parse(@path).render context

      site_source = context.registers[:site].config['source']
      # check direct .md file
      page_path = [ site_source, url.strip[0..-2], '.md' ].compact.join('')
      if File.exist?(page_path)
        return true
      end

      # check index.md file
      page_path = [ site_source, url.strip, 'index.md' ].compact.join('')
      if File.exist?(page_path)
        return true
      end

      # not found
      false
    end
  end
end

Liquid::Template.register_tag('page_exists', Jekyll::PageExistsTag)
