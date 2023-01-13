module SharedContexts
  module Site
    extend ::RSpec::SharedContext

    let(:config) do
      Jekyll.configuration(
        source: File.expand_path('../../fixtures/app', __dir__),
        destination: File.expand_path('../../fixtures/dist', __dir__),
        quiet: true,
        permalink: 'pretty',
        'jekyll-generator-single-source': {
          'versions_file' => '_data/kong_versions.yml',
          'docs_nav_folder' => '_data',
        },
        defaults: [
          { 'scope' => { 'path' => '' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'enterprise' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'gateway-oss' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'install' }, 'values' => { 'layout' => 'install' } },
          { 'scope' => { 'path' => 'getting-started-guide' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'deck' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'mesh' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'kubernetes-ingress-controller' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'konnect' }, 'values' => { 'layout' => 'docs-v2', 'no_version' => true } },
          { 'scope' => { 'path' => 'gateway' }, 'values' => { 'layout' => 'docs-v2' } },
          { 'scope' => { 'path' => 'gateway/2.6.x/' }, 'values' => { 'layout' => 'docs-v2', 'version-index' => 0 } },
          { 'scope' => { 'path' => 'gateway/2.7.x/' }, 'values' => { 'layout' => 'docs-v2', 'version-index' => 1 } },
          { 'scope' => { 'path' => 'gateway/2.8.x/' }, 'values' => { 'layout' => 'docs-v2', 'version-index' => 2 } },
          { 'scope' => { 'path' => 'about' }, 'values' => { 'layout' => 'about', 'header_html' => '<a class=\'github-button\' href=\'https://github.com/Kong/kong\' data-style=\'mega\' data-count-href=\'/Kong/kong/stargazers\' data-count-api=\'/repos/Kong/kong#stargazers_count\' data-count-aria-label=\'# stargazers on GitHub\' aria-label=\'Star Kong/kong on GitHub\'>Star</a>&nbsp;<a class=\'github-button\' href=\'https://github.com/Kong/kong/fork\' data-icon=\'octicon-repo-forked\' data-style=\'mega\' data-count-href=\'/Kong/kong/network\' data-count-api=\'/repos/Kong/kong#forks_count\' data-count-aria-label=\'# forks on GitHub\' aria-label=\'Fork Kong/kong on GitHub\'>Fork</a>', 'breadcrumbs' => '' } },
          { 'scope' => { 'type' => 'hub' }, 'values' => {  'layout' => 'extension', 'permalink' => '/:collection/:path' } },
          { 'scope' => { 'path' => 'contributing' }, 'values' => { 'layout' => 'docs-v2' } }
        ],
        plugins: ['jekyll-redirect-from', 'jekyll-include-cache', 'jekyll-generator-single-source']
      )
    end

    let(:site) do
      site = Jekyll::Site.new(config)
      site.read
      site
    end
  end
end
