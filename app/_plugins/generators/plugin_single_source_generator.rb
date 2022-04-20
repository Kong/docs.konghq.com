# frozen_string_literal: true

module PluginSingleSource
  class Generator < Jekyll::Generator
    priority :highest
    def generate(site) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      site.data['ssg_hub'] = []
      seen = []

      Dir.glob('app/_data/extensions/*/*/versions.yml').each do |f|
        name = f.gsub('app/_data/extensions/', '').gsub('/versions.yml', '')
        seen << name
        data = SafeYAML.load(File.read(f))
        create_pages(data, site, name)
      end

      # Add any files that did not have a corresponding versions.yml
      Dir.glob('app/_hub/*/*/_index.md').each do |f|
        name = f.gsub('app/_hub/', '').gsub('/_index.md', '')
        next if seen.include?(name)

        create_pages([{ 'release' => '1.0.0' }], site, name) # If there's no version, assume it's 1.0.0
      end
    end

    def create_pages(versions, site, name) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
      version_strings = versions.map do |v|
        v['release'].gsub('-', '.').gsub(/\.x/, '.0')
      end
      max_version = version_strings.max_by { |v| Gem::Version.new(v) }
      set_version = versions.size > 1
      versions.each do |v, _k|
        current_version = v['release'].gsub('-', '.').gsub(/\.x/, '.0')
        # Skip if a markdown file exists for this version
        # and we're not generating the index version
        next if File.exist?("app/_hub/#{name}/#{v['release']}.md") && current_version != max_version

        # Otherwise duplicate the source file, fallback to _index.md
        source = v['source'] || '_index'

        unless source.start_with?('_')
          raise "Plugin source files must start with an _ to prevent Jekyll from rendering them directly. Please fix [#{source}] in [#{name}]" # rubocop:disable Layout/LineLength
        end

        plugin = name.split('/')
        source_path = "app/_hub/#{name}/#{source}.md"

        # Add the index page rendering if we're on the latest release too
        permalink = v['release']
        permalink = 'index' if current_version == max_version

        page = SingleSourcePage.new(site, v['release'], plugin[0], plugin[1], source, source_path, permalink,
                                    set_version)
        site.pages << page

        # Make sure we add the page to site.hub for later iteration
        site.data['ssg_hub'] << page if permalink == 'index'
      end
    end
  end

  class SingleSourcePage < Jekyll::Page
    def initialize(site, version, author, plugin_name, source_file, source_path, permalink_name, set_version) # rubocop:disable Lint/MissingSuper, Metrics/AbcSize, Metrics/MethodLength, Metrics/ParameterLists
      # Configure variables that Jekyll depends on
      @site = site

      # Make sure the source path is still index.md to generate the extension listing
      @path = source_path.gsub(source_file, permalink_name)

      # Set self.ext and self.basename by extracting information from the page filename
      process("#{version}.md")

      # This is the directory that we're going to write the output file to
      @dir = "hub/#{author}/#{plugin_name}"

      content = File.read(source_path)

      # Load content + frontmatter from the file
      if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
        @content = Regexp.last_match.post_match
        @data = SafeYAML.load(Regexp.last_match(1))
      end

      @data['version'] = version if set_version
      @data['is_latest'] = permalink_name == 'index'

      # We need to set the path so that some of the conditionals in templates
      # continue to work.
      @data['path'] = "_hub/#{author}/#{plugin_name}/#{permalink_name}.md"

      # The plugin hub uses version.html as the filename unless it's the most
      # recent version, in which case it uses index
      @data['permalink'] = "#{@dir}/"
      @data['permalink'] = "#{@data['permalink']}#{permalink_name}.html" unless permalink_name == 'index'

      # Set the layout if it's not already provided
      @data['layout'] = 'extension' unless data['layout']
    end
  end
end
