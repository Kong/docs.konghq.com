# frozen_string_literal: true

module Jekyll
  class KGOPodtemplatespecExample < Liquid::Block
    def render(context) # rubocop:disable Metrics/AbcSize
      spec = super

      config = YAML.safe_load(spec)

      gateway_config_api_version = config['gatewayConfigApiVersion']
      dp = config['dataplane'].to_yaml.split("\n")[1..].join("\n")
      cp = config['controlplane'].to_yaml.split("\n")[1..].join("\n")

      <<~TEXT
        #{dataplane_example(dp, config['release']) if config['dataplane']}#{' '}
        #{gateway_config_example(gateway_config_api_version, dp, cp, config['release'])}
      TEXT
    end

    private

    def config_example(field, spec)
      return '' if spec.empty?

      options = <<~SPEC
        #{field}:
          deployment:
            podTemplateSpec:
              #{spec.split("\n").map { |line| "      #{line}" }.join("\n").strip}
      SPEC

      options.split("\n").map { |line| "      #{line}" }.join("\n").strip
    end

    def release_to_version(release)
      # Extract the major and minor version numbers from the release string
      major, minor = release.split('.').map(&:to_i)[0, 2]
      # Determine the return value based on the extracted version numbers
      if major == 1 && minor == 1
        'v1beta1'
      else
        # Use v1 as both the default fallback and the return value for 1.1.x and up.
        'v1'
      end
    end

    def gateway_config_example(gateway_config_api_version, dataplane, controlplane, release) # rubocop:disable Metrics/MethodLength
      gateway_api_version = release_to_version(release)

      <<~TEXT

        ### Using GatewayConfiguration

        {:.note}
        > This method is only available when running in [DB-less mode](/gateway-operator/#{release}/topologies/dbless/)

        The `GatewayConfiguration` resource is a Kong-specific API which allows you to set both `controlPlaneOptions` and `dataPlaneOptions`.

        You can customize both the container image and version.

        1.  Define the image in the `GatewayConfiguration`.

            ```yaml
            kind: GatewayConfiguration
            apiVersion: gateway-operator.konghq.com/#{gateway_config_api_version}
            metadata:
              name: kong
              namespace: default
            spec:
              #{config_example('dataPlaneOptions', dataplane)}
              #{config_example('controlPlaneOptions', controlplane)}
            ```

        1.  Reference this configuration in the `GatewayClass` resource for the deployment.

            ```yaml
            kind: GatewayClass
            apiVersion: gateway.networking.k8s.io/#{gateway_api_version}
            metadata:
              name: kong
            spec:
              controllerName: konghq.com/gateway-operator
              parametersRef:
                group: gateway-operator.konghq.com
                kind: GatewayConfiguration
                name: kong
                namespace: default
            ```

        1.  Use the `GatewayClass` in your `Gateway`.

            ```yaml
            kind: Gateway
            apiVersion: gateway.networking.k8s.io/#{gateway_api_version}
            metadata:
              name: kong
              namespace: default
            spec:
              gatewayClassName: kong
              listeners:
              - name: http
                protocol: HTTP
                port: 80
            ```

      TEXT
    end

    def dataplane_example(spec, release) # rubocop:disable Metrics/MethodLength
      return '' if spec.empty?

      <<~TEXT
        ### Using DataPlane

        {:.note}
        > This method is only available when running in [hybrid mode](/gateway-operator/#{release}/topologies/hybrid/)

        The `DataPlane` resource uses the Kubernetes [PodTemplateSpec](/gateway-operator/#{release}/customization/pod-template-spec/) to define how the Pods should run.

        ```yaml
        apiVersion: gateway-operator.konghq.com/v1beta1
        kind: DataPlane
        metadata:
          name: dataplane-example
          namespace: kong
        spec:
          deployment:
            podTemplateSpec:
              #{spec.split("\n").map { |line| "      #{line}" }.join("\n").strip}
        ```
      TEXT
    end
  end
end

Liquid::Template.register_tag('kgo_podtemplatespec_example', Jekyll::KGOPodtemplatespecExample)
