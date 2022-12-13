# frozen_string_literal: true

module Jekyll
  class InstallPages < Jekyll::Generator
    priority :medium

    def generate(site)
      latest_page = site.pages.detect { |p| p.relative_path == 'install/latest.md' }
      latest_page.data['version'] = site.data['latest_version']['release']
      latest_page.data['has_version'] = true

      site.data['versions'].each do |version|
        site.pages << InstallPage.new(site, version)
      end
    end
  end

  class InstallPage < Jekyll::Page
    def initialize(site, version)
      @site = site
      @dir  = 'install'

      process("#{version['release']}.md")

      content = File.read('app/install/latest.md')

      # Load content + frontmatter from the file
      if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
        @content = Regexp.last_match.post_match
        @data = SafeYAML.load(Regexp.last_match(1))
      end

      @data['version'] = version['release']
      @data['has_version'] = true
    end
  end
end
