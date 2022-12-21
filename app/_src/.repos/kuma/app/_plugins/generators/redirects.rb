# frozen_string_literal: true

module Jekyll
  class Redirects < Jekyll::Generator
    priority :low

    def generate(site)
      current_redirects = File.read("app/_redirects")
      active_versions = site.data['versions'].filter {|v| v['release'] != "dev"}

      # Generate redirects for the latest version
      latest_release = site.data['latest_version']['release']
      redirects = [
        "# Generated redirects",
        "/docs /docs/#{latest_release} 301",
        "/install/kong-gateway /docs/#{latest_release}/explore/gateway 301",
        "/docs/latest/documentation/gateway /docs/#{latest_release}/explore/gateway 301",
        "/docs/latest/deployments /docs/:version/#{latest_release}/deployments 301",
        "/docs/latest/documentation/deployments /docs/#{latest_release}/introduction/deployments 301",
        "/docs/latest/explore/backends /docs/#{latest_release}/documentation/configuration 301",
        "/install /install/#{latest_release} 301",
        "/docs/latest/* /docs/#{latest_release}/:splat 301",
        "/install/latest/* /install/#{latest_release}/:splat 301",
        "/docs/:version/policies/ /docs/:version/policies/introduction 301",
        "/docs/:version/overview/ /docs/:version/overview/what-is-kuma 301",
        "/docs/:version/other/ /docs/:version/other/enterprise 301",
        "/docs/:version/installation/ /docs/:version/installation/kubernetes 301",
        "/docs/:version/api/ /docs/:version/documentation/http-api 301",
        "/docs/:version/documentation/deployments/ /docs/:version/introduction/deployments 301",
        "/latest_version.html /latest_version 301",
      ].join("\n")

      # Generate redirects for specific versions
      redirects = "#{redirects}\n\n# Specific version to release\n"
      active_versions.each do |v|
        vp = v['version'].split('.').map(&:to_i)

        # Generate redirects for x.y.0, x.y.1, x.y.2 etc
        # Until we hit the actual version stored in versions.yml
        for idx in 0..vp[2] do
          current = "#{vp[0]}.#{vp[1]}.#{idx}"
          redirects = <<~RDR
          #{redirects}/docs/#{current}/*  /docs/#{v['release']}/:splat  301
          /install/#{current}/*  /install/#{v['release']}/:splat  301
          RDR
        end 
      end

      # Generate policy redirects
      policy_redirects = [
        ['circuit-breakers', 'circuit-breaker'],
        ['fault-injections', 'fault-injection'],
        ['health-checks', 'health-check'],
        ['meshgateways', 'mesh-gateway'],
        ['meshgatewayroutes', 'mesh-gateway-route'],
        ['proxytemplates', 'proxy-template'],
        ['rate-limits', 'rate-limit'],
        ['retries', 'retry'],
        ['timeouts', 'timeout'],
        ['traffic-logs', 'traffic-log'],
        ['traffic-routes', 'traffic-route'],
        ['traffic-traces', 'traffic-trace'],
        ['virtual-outbounds', 'virtual-outbound'],
      ].map {|v| "/docs/:version/policies/#{v[0]}/ /docs/:version/policies/#{v[1]}/ 301"}.join("\n")

      # Kuma tag redirects
      kuma_tag_redirects = [
        'builtindns',
        'builtindnsport',
        'container-patches',
        'direct-access-services',
        'envoy-admin-port',
        'gateway',
        'ignore',
        'ingress-public-address',
        'ingress-public-port',
        'ingress',
        'mesh',
        'service-account-token-volume',
        'sidecar-drain-time',
        'sidecar-env-vars',
        'sidecar-injection',
        'transparent-proxying-experimental-engine',
        'transparent-proxying-inbound-v6-port',
        'transparent-proxying-reachable-services',
        'virtual-probes-port',
       'virtual-probes',
      ].map{ |source_path| "/#{source_path}/ /docs/#{latest_release}/reference/kubernetes-annotations/#kumaio#{source_path} 301" }.join("\n")

      kuma_subdomain_redirects = [
        ['https://prometheus.metrics.kuma.io/port', "/docs/#{latest_release}/reference/kubernetes-annotations/#prometheus-metrics-kuma-io-port"],
        ['https://prometheus.metrics.kuma.io/path', "/docs/#{latest_release}/reference/kubernetes-annotations/#prometheus-metrics-kuma-io-path"],
        ['https://traffic.kuma.io/exclude-inbound-ports', "/docs/#{latest_release}/reference/kubernetes-annotations/#traffic-kuma-io-exclude-inbound-ports"],
        ['https://traffic.kuma.io/exclude-outbound-ports', "/docs/#{latest_release}/reference/kubernetes-annotations/#traffic-kuma-io-exclude-outbound-ports"],
      ].map{ |v| "#{v[0]} #{v[1]}/ 301" }.join("\n")


      redirects = <<~RDR
      #{redirects}
      # Policy redirects
      #{policy_redirects}

      # kuma.io/* tag redirects
      #{kuma_tag_redirects}

      # kuma.io subdomain redirects
      #{kuma_subdomain_redirects}
      RDR

      # Add all hand-crafted redirects
      redirects = <<~RDR 
        #{redirects}

        # Original _redirects file:
        #{current_redirects}
      RDR

      write_file(site, "_redirects", redirects)
    end

    def write_file(site, path, content)
      page = PageWithoutAFile.new(site, __dir__, '', path)
      page.content = content
      page.data['layout'] = nil
      site.pages << page
    end
  end
end
