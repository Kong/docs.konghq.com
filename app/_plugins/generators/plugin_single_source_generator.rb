# frozen_string_literal: true

module PluginSingleSource
  class Generator < Jekyll::Generator
    priority :normal

    PLUGINS_FOLDER = '_hub'
    SAMPLE_PLUGIN = '_init/my-extension'

    def generate(site)
      site.data['ssg_hub'] = []

      return if ENV['DISABLE_HUB']
      return if ENV['KONG_PRODUCTS'] && !ENV['KONG_PRODUCTS'].include?('hub')

      generate_pages(site)
    end

    def generate_pages(site)
      plugins(site).map do |plugin|
        pages = plugin.create_pages

        site.pages.concat(pages)

        # Make sure we add the page to site.hub for later iteration
        # only overview pages...
        site.data['ssg_hub'].concat(
          pages.select { |p| p.data['ssg_hub'] == true }
        )
      end
    end

    private

    def plugins(site)
      @plugins ||=
        Dir.glob(File.join(site.source, "#{PLUGINS_FOLDER}/*/*/")).map do |dir_path|
          dir = dir_path.gsub("#{site.source}/#{PLUGINS_FOLDER}/", '').chomp('/')

          next if dir == SAMPLE_PLUGIN

          Plugin::Base.make_for(dir:, site:)
        end.compact
    end
  end
end
