# frozen_string_literal: true

require 'json'

module Jekyll
  module JSONPrettifyFilter
    def json_prettify(input)
      JSON.pretty_generate(input)
    end
  end
end

Liquid::Template.register_filter(Jekyll::JSONPrettifyFilter)
