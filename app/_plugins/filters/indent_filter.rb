# frozen_string_literal: true

module IndentFilter
  def indent(input)
    input.gsub(/\n/, "\n    ")
  end
end

Liquid::Template.register_filter(IndentFilter)
