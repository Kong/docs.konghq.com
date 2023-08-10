# frozen_string_literal: true

module OasDefinition
  class PageUrlGenerator
    def self.run(file:, version:)
      new(file:, version:).run
    end

    def initialize(file:, version:)
      @file = file
      @version = version
    end

    def run
      base_url.concat("#{api_segment}/") if namespaced?
      base_url.concat("#{@version}/")
    end

    private

    def namespace
      @namespace ||= @file.split('/')[1]
    end

    def base_url
      @base_url ||= "/#{namespace}/api/"
    end

    def api_segment
      @api_segment ||= @file.split('/')[2]
    end

    def namespaced?
      @file.split('/').size > 3
    end
  end
end
