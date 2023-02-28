# frozen_string_literal: true

module Utils
  class FrontmatterParser
    def initialize(string)
      @string = string

      @result = @string.match(Jekyll::Document::YAML_FRONT_MATTER_REGEXP)
    end

    def frontmatter
      @frontmatter ||= if @result.nil?
                         {}
                       else
                         SafeYAML.load(@result.match(1)) || {}
                       end
    end

    def content
      @content ||= @result.nil? ? @string : @result.post_match
    end
  end
end
