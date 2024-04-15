# frozen_string_literal: true

module QuoteFilter
  def quote(input)
    if input.is_a?(Numeric)
      input
    else
      "\"#{input}\""
    end
  end
end

Liquid::Template.register_filter(QuoteFilter)
