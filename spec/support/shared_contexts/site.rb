module SharedContexts
  module Site
    extend ::RSpec::SharedContext

    let(:config) do
      Jekyll.configuration(
        YAML.safe_load(
          File.read(File.expand_path('../../../jekyll.yml', __dir__))
        ).merge(
          source: File.expand_path('../../fixtures/app', __dir__),
          destination: File.expand_path('../../fixtures/dist', __dir__),
          quiet: true
        )
      )
    end

    let(:site) do
      site = Jekyll::Site.new(config)
      site.read
      site
    end

    def render_page(page:)
      layouts = {
        'extension' => Jekyll::Layout.new(site, '_layouts', 'extension.html'),
        'default' => Jekyll::Layout.new(site, '_layouts', 'default.html'),
      }
      site.layouts = layouts

      page.render(layouts, site.site_payload)
    end

    def find_page_by_url(url)
      site.instance_variable_get(:@pages).detect { |p| p.url == url }
    end

    def generate_site!
      Jekyll::GeneratorSingleSource::Generator.new.generate(site)
      PluginSingleSource::Generator.new.generate(site)
      Jekyll::Versions.new.generate(site)
      LatestVersion::Generator.new.generate(site)
    end
  end
end
