# frozen_string_literal: true

module PluginSingleSource
  class SingleSourcePage < Jekyll::Page
    def initialize(site:, release:) # rubocop:disable Lint/MissingSuper
      # Configure variables that Jekyll depends on
      @site = site

      unless release.source.start_with?('_')
        raise ArgumentError,
              "Plugin source files must start with an _ to prevent Jekyll from rendering them directly. Please fix [#{release.source}] in [#{release.dir}]" # rubocop:disable Layout/LineLength
      end

      # Set self.ext and self.basename by extracting information from the page filename
      process("#{release.version}.md")

      # This is the directory that we're going to write the output file to
      @dir = "hub/#{release.dir}"

      # Set page content
      @content = release.content
      # Inject data into the template
      @data = release.data

      # Needed so that regeneration works for single sourced pages
      # It must be set to the source file
      # Also, @path MUST NOT be set, it falls back to @relative_path
      @relative_path = release.source_file
    end
  end
end
