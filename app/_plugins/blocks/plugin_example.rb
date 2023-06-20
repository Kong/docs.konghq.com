# frozen_string_literal: true

#
# Example usage in markdown files:
# ----------------------------------------
#
# {% plugin_example %}
# name: rate-limit-example
# plugin: kong-inc/rate-limiting
# example: complex-example
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

      examples = Jekyll::InlinePluginExample::Config.new(
        config: SafeYAML.load(contents),
        page:
      ).examples

      Liquid::Template
        .parse(template)
        .render(
          { 'page' => page, 'include' => { 'hub_examples' => examples } },
          { registers: context.registers }
        )
    end

    def template
      @template ||= File.read(File.expand_path('app/_includes/hub-examples.html'))
    end
  end
end

Liquid::Template.register_tag('plugin_example', Jekyll::PluginExample)
