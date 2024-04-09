# frozen_string_literal: true

module Jekyll
  class TranslateTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super

      @key = markup.strip
    end

    def render(context)
      Liquid::Template.parse(I18n.t(@key)).render(context)
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::TranslateTag)
