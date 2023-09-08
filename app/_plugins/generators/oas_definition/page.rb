# frozen_string_literal: true

module OasDefinition
  class Page < ::Jekyll::Page
    def initialize(site:, data:) # rubocop:disable Lint/MissingSuper
      @site = site
      @base = site.source
      @dir = data['dir']

      @basename = 'index'
      @ext = '.html'

      @data = data
      @content = ''
      @relative_path = data['source_file']
    end
  end
end
