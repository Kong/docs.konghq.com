# frozen_string_literal: true

module ToCheckFilter
  def to_check(input)
    return '✅' if input

    '❌'
  end
end

Liquid::Template.register_filter(ToCheckFilter)
