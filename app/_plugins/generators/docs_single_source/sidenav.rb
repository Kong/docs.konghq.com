# frozen_string_literal: true

module DocsSingleSource
  class Sidenav
    def initialize(page)
      @page = page
    end

    def generate
      return unless @page.data['nav_items']

      ::Jekyll::Drops::Sidenav.new(@page.data['nav_items'], options)
    end

    private

    def options
      { 'docs_url' => @page.data['edition'], 'version' => version }
    end

    def version
      return if @page.data['edition'] == 'konnect'

      if @page.data['is_latest']
        'latest'
      else
        @page.data['kong_version']
      end
    end
  end
end
