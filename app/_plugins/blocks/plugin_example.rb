# frozen_string_literal: true

#
# Example usage in markdown files:
# ----------------------------------------
#
# {% plugin_example %}
# title: Rate Limiting Opinionated Example
# plugin: kong-inc/rate-limiting
# name: rate-limiting
# config:
#  hour: 5
#  policy: local
# targets:
#   - service
#   - route
#   - consumer
#   - global
# formats:
#   - curl
#   - yaml
#   - kubernetes
# {% endplugin_example %}

module Jekyll
  class PluginExample < Liquid::Block
    def render(context) # rubocop:disable Metrics/MethodLength
      @context = context
      contents = super
      page = context.environments.first['page']
      site = context.registers[:site]

      config = Jekyll::InlinePluginExample::Config.new(
        config: SafeYAML.load(contents),
        page:,
        site:
      )

      Liquid::Template
        .parse(template)
        .render(
          {
            'page' => page,
            'include' => { 'hub_examples' => config.examples, 'title' => config.title }
          },
          { registers: context.registers }
        )
    end

    def template
      @template ||= File.read(File.expand_path('app/_includes/hub-examples.html'))
    end
  end
end

Liquid::Template.register_tag('plugin_example', Jekyll::PluginExample)
