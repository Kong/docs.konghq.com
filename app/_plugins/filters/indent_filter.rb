# frozen_string_literal: true

module IndentFilter
  def indent(input)
    input
      .gsub("\n</code>", '</code>')
      .split("\n")
      .map { |l| l.prepend('   ') }
      .join("\n")
  end
end

Liquid::Template.register_filter(IndentFilter)
