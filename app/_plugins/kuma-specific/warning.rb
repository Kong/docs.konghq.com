# frozen_string_literal: true

module Jekyll
  class Warning < Liquid::Block
    def initialize(tag_name, markup, options)
      super

      @markup = markup.strip
    end

    def render(context)
      content = Kramdown::Document.new(super).to_html

      # warnings in Kuma map to {:.important} in docs
      <<~TIP
        <blockquote class="important">
          <p>#{content}</p>
        </blockquote>
      TIP
    end
  end
end

Liquid::Template.register_tag('warning', Jekyll::Warning)
