# frozen_string_literal: true

module Jekyll
  class TranslateTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super

      @key = markup.strip
    end

    def render(context)
      if I18n.exists?(@key)
        I18n.t(@key)
      else
        # TODO: check if this key is equal to @key
        # if it is not, then it's a variable
        key = Liquid::Template.parse(@key).render(context)
        I18n.t(key)
      end
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::TranslateTag)
