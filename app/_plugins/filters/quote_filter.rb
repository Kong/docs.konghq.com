# frozen_string_literal: true

module QuoteFilter
  def quote(input)
    return input if ['true', 'false', true, false].include?(input)

    return input if input.is_a?(Numeric)

    "\"#{input}\""
  end
end

Liquid::Template.register_filter(QuoteFilter)
