# frozen_string_literal: true

module BadgeFilter
  def to_badges(input)
    input.map do |i|
      "<span class='badge #{i}'></span>"
    end   
  end
end

Liquid::Template.register_filter(BadgeFilter)
