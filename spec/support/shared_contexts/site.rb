module SharedContexts
  module Site
    extend ::RSpec::SharedContext

    let(:config) do
      Jekyll.configuration(
        source: File.expand_path('../../fixtures/app', __dir__),
        destination: File.expand_path('../../fixtures/dist', __dir__),
        quiet: true
      )
    end

    let(:site) do
      site = Jekyll::Site.new(config)
      site.read
      site
    end
  end
end
