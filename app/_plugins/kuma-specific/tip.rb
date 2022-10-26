# frozen_string_literal: true

module Jekyll
  class Tip < Liquid::Block
    def initialize(tag_name, markup, options)
      super

      @markup = markup.strip
    end

    def render(context)
      content = Kramdown::Document.new(super).to_html
      <<~TIP
        <blockquote class="note">
          <p>#{content}</p>
        </blockquote>
      TIP
    end
  end
end

Liquid::Template.register_tag('tip', Jekyll::Tip)
