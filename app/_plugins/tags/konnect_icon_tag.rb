# frozen_string_literal: true

module Jekyll
  class KonnectIconTag < Liquid::Tag
    def initialize(tag_name, icon, tokens)
      super
      @icon = icon.strip
    end

    def render(_context)
      "![#{@icon} icon](/assets/images/icons/konnect/icn-#{@icon}.svg){:.inline .konnect-icn .no-image-expand}"
    end
  end
end

Liquid::Template.register_tag('konnect_icon', Jekyll::KonnectIconTag)
