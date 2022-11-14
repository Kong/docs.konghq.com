# frozen_string_literal: true

module PluginSingleSource
  class SingleSourcePage < Jekyll::Page
    def initialize(site:, version:, plugin:, is_latest:, source:) # rubocop:disable Lint/MissingSuper, Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      # Configure variables that Jekyll depends on
      @site = site

      unless source.start_with?('_')
        raise ArgumentError,
              "Plugin source files must start with an _ to prevent Jekyll from rendering them directly. Please fix [#{source}] in [#{plugin.dir}]" # rubocop:disable Layout/LineLength
      end

      permalink_name = is_latest ? 'index' : version

      # Make sure the source path is still index.md to generate the extension listing
      @path = File.join(site.source, Generator::PLUGINS_FOLDER, plugin.dir, "#{permalink_name}.md")

      # Set self.ext and self.basename by extracting information from the page filename
      process("#{version}.md")

      # This is the directory that we're going to write the output file to
      @dir = "hub/#{plugin.dir}"

      source_path = "#{Generator::PLUGINS_FOLDER}/#{plugin.dir}/#{source}.md"
      content = File.read(File.expand_path(source_path, site.source))

      # Load content + frontmatter from the file
      if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
        @content = Regexp.last_match.post_match
        @data = SafeYAML.load(Regexp.last_match(1))
      end

      @data['version'] = version if plugin.set_version?
      @data['is_latest'] = is_latest

      @data['canonical_url'] = "/hub/#{plugin.dir}/" unless is_latest
      @data['seo_noindex'] = true unless is_latest

      # We need to set the path so that some of the conditionals in templates
      # continue to work.
      @data['path'] = "_hub/#{plugin.dir}/#{permalink_name}.md"

      # The plugin hub uses version.html as the filename unless it's the most
      # recent version, in which case it uses index
      @data['permalink'] = "#{@dir}/"
      @data['permalink'] = "#{@data['permalink']}#{permalink_name}.html" unless is_latest

      # Set the layout if it's not already provided
      @data['layout'] = 'extension' unless data['layout']
    end
  end
end
