# frozen_string_literal: true

require 'active_support/core_ext/string/inflections' # If not using Rails

ActiveSupport::Inflector.inflections do |inflect|
  inflect.acronym 'API'
  inflect.acronym 'mTLS'
  inflect.acronym 'PDK'
  inflect.acronym 'OIDC'
end

module Jekyll
  module TitleizeFilter
    def titleize(input)
      input.titleize
    end
  end
end

Liquid::Template.register_filter(Jekyll::TitleizeFilter)
