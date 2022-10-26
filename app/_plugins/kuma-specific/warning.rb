# frozen_string_literal: true

module Jekyll
  class Warning < Liquid::Block
    def initialize(tag_name, markup, options)
      super

      @markup = markup.strip
    end

    def render(context)
      content = Kramdown::Document.new(super).to_html

      <<~TIP
        <div class="custom-block warning">
          <p>#{content}</p>
        </div>
      TIP
    end
  end
end

Liquid::Template.register_tag('warning', Jekyll::Warning)
