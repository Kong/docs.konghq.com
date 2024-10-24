# frozen_string_literal: true

module Jekyll
  class CustomBlock < Liquid::Block
    def initialize(tag_name, markup, options)
      super
      # Classes differs between Kuma and Kong docs, but they have the same
      # underlying meanings
      @class_name = {
        'tip' => 'note',
        'warning' => 'important',
        'danger' => 'warning'
      }.fetch(tag_name, 'note')
    end

    def render(context)
      content = Kramdown::Document.new(super).to_html
      <<~HTML
        <blockquote class="#{@class_name}">
          <p>#{content}</p>
        </blockquote>
      HTML
    end
  end
end

Liquid::Template.register_tag('tip', Jekyll::CustomBlock)
Liquid::Template.register_tag('warning', Jekyll::CustomBlock)
Liquid::Template.register_tag('danger', Jekyll::CustomBlock)
