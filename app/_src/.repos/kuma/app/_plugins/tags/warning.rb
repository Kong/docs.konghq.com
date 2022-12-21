module Jekyll
  class Warning < Liquid::Block
    alias_method :render_block, :render

    def initialize(tag_name, markup, options)
      super

      @markup = markup.strip
    end

    def render(context)
      site = context.registers[:site]
      converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
      content = converter.convert(render_block(context))

      <<~TIP
        <div class="custom-block warning">
          <p>#{content}</p>
        </div>
      TIP
    end
  end
end

Liquid::Template.register_tag('warning', Jekyll::Warning)
