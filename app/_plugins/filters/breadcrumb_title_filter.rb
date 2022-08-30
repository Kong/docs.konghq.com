# frozen_string_literal: true

require 'yaml'
module Jekyll
  module BreadcrumbTitleFilter
    def initialize(_)
      super(_)
      @mapping = YAML.load_file("#{__dir__}/../../breadcrumb_titles.yml")
    end
    def breadcrumb_title(input)
      @mapping[input]
    end
  end
end

Liquid::Template.register_filter(Jekyll::BreadcrumbTitleFilter)
