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

      # Set self.ext and self.basename by extracting information from the page filename
      process("#{version}.md")

      # This is the directory that we're going to write the output file to
      @dir = "hub/#{plugin.dir}"

      source_path = if source == '_index'
                      "#{Generator::PLUGINS_FOLDER}/#{plugin.dir}/#{source}.md"
                    else
                      "#{Generator::PLUGINS_FOLDER}/#{plugin.dir}/#{source}/_index.md"
                    end
      content = File.read(File.expand_path(source_path, site.source))

      # Load content + frontmatter from the file
      if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
        @content = Regexp.last_match.post_match
        @data = SafeYAML.load(Regexp.last_match(1))
      end

      # TODO: temporary for now
      # ------------
      # CONFIGURATION PARAMETERS TABLE
      # ------------
      configuration_params_table_path = if source == '_index'
                                          File.expand_path("#{Generator::PLUGINS_FOLDER}/#{plugin.dir}/_configuration.yml", site.source)
                                        else
                                          # Specific version file
                                          File.expand_path("#{Generator::PLUGINS_FOLDER}/#{plugin.dir}/#{source}/_configuration.yml", site.source)
                                        end
      if File.exists?(configuration_params_table_path)
        @data.merge!(SafeYAML.load(File.read(configuration_params_table_path)))
      end

      # ------------
      # CHANGELOG...
      # ------------
      changelog_path = if source == '_index'
                         File.expand_path("#{Generator::PLUGINS_FOLDER}/#{plugin.dir}/_changelog.md", site.source)
                       else
                         # Specific version file
                         File.expand_path("#{Generator::PLUGINS_FOLDER}/#{plugin.dir}/#{source}/_changelog.md", site.source)
                       end
      if File.exists?(changelog_path)
        @content << File.read(changelog_path)
      end
      #-------------

      @data['version'] = version if plugin.set_version?
      @data['is_latest'] = is_latest

      @data['canonical_url'] = "/hub/#{plugin.dir}/" unless is_latest
      @data['seo_noindex'] = true unless is_latest

      # The plugin hub uses version.html as the filename unless it's the most
      # recent version, in which case it uses index
      @data['permalink'] = "#{@dir}/"
      @data['permalink'] = "#{@data['permalink']}#{permalink_name}.html" unless is_latest

      # Set the layout if it's not already provided
      @data['layout'] = 'extension' unless data['layout']

      @data['source_file'] = source_path
      @data['extn_slug'] = plugin.name
      @data['extn_publisher'] = plugin.vendor
      @data['extn_icon'] = @data['header_icon'] || "/assets/images/icons/hub/#{plugin.vendor}_#{plugin.name}.png"
      @data['extn_release'] = version

      # Needed so that regeneration works for single sourced pages
      # It must be set to the source file
      # Also, @path MUST NOT be set, it falls back to @relative_path
      @relative_path = source_path

      # Override any frontmatter as required
      unless plugin.respond_to?(:ext_data) && plugin.ext_data['frontmatter'] && plugin.ext_data['frontmatter'][version]
        return
      end

      plugin.ext_data['frontmatter'][version].each do |k, v|
        @data[k] = v
      end
    end
  end
end
