# frozen_string_literal: true

require 'yaml'
module Jekyll
  module BreadcrumbTitleFilter
    def initialize(ctx)
      super
      @mapping = YAML.load_file("#{__dir__}/../../breadcrumb_titles.yml")
    end

    def breadcrumb_title(input)
      parts = input.split('/')
      parts[2] = 'VERSION'
      input = "#{parts.join('/')}/"
      @mapping[input]
    end
  end
end

Liquid::Template.register_filter(Jekyll::BreadcrumbTitleFilter)
