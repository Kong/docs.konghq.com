# frozen_string_literal: true

module PluginSingleSource
  class SingleSourcePage < Jekyll::Page
    def initialize(site:, page:) # rubocop:disable Lint/MissingSuper
      # Configure variables that Jekyll depends on
      @site = site

      # Set self.ext and self.basename by extracting information from the page filename
      process("#{page.version}.md")

      # This is the directory that we're going to write the output file to
      @dir = page.dir

      # Set page content
      @content = page.content

      # Inject data into the template
      @data = page.data

      # Needed so that regeneration works for single sourced pages
      # It must be set to the source file
      # Also, @path MUST NOT be set, it falls back to @relative_path
      @relative_path = page.source_file
    end
  end
end
