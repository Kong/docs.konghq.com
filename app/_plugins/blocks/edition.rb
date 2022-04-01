module Jekyll
  class EditionTagBlock < Liquid::Block
    def initialize(tag_name, markup, tokens)
      super
      @edition = markup.strip
    end

    def render(context)
      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
      "<div data-edition='" + @edition + "'>" + converter.convert(super(context)) + "</div>"
    end
  end
end

Liquid::Template.register_tag('edition', Jekyll::EditionTagBlock)
