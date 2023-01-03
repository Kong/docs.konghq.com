# frozen_string_literal: true

module SEO
  class Index
    def self.generate(site)
      new(site).generate
    end

    attr_reader :index

    def initialize(site)
      @site = site
      @index = {}
    end

    def generate
      # Build up an index of the latest URLs for each page
      generate_index

      @index
    end

    def entries
      @entries ||= @site.pages.map do |page|
        IndexEntryBuilder.for(page)
      end
    end

    private

    def generate_index
      entries.each do |entry|
        @index[entry.key] = entry.attributes if entry.indexable?(@index)
      end
    end
  end
end
