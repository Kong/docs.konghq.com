# frozen_string_literal: true

# Example usage in markdown files:
# ----------------------------------------
# {% navtabs custom-class %}
# {% navtab With a database %}
#
# {{ plugin_config_for_service_with_db }}
#
# {% endnavtab %}
# {% navtab Without a database %}
#
# Configure this plugin on a [Service](/latest/admin-api/#service-object) by
# adding this section do your declarative configuration file:
#
# ``` yaml
# plugins:
# - name: {{page.params.name}}
#   service: {service}
#   {{ config_required_fields_yaml }}
# ```
# {% endnavtab %}
# {% endnavtabs %}
# ----------------------------------------
#
# `navtabs` - tabs container
# `custom-class` - optional parameter for class added to navtabs container for further customization
# `navtab title` - specifies single tab with its title
#

require 'erb'
require 'securerandom'

module Jekyll
  module NavTabs
    class NavTabsBlock < Liquid::Block
      def initialize(tag_name, markup, tokens)
        super
        @class = markup.strip
      end

      def render(context) # rubocop:disable Metrics/MethodLength
        navtabs_id = SecureRandom.uuid
        environment = context.environments.first
        environment["navtabs-#{navtabs_id}"] = {}
        environment['navtabs-stack'] ||= []

        environment['navtabs-stack'].push(navtabs_id)
        super
        environment['navtabs-stack'].pop

        environment['additional_classes'] = ''
        environment['additional_classes'] = 'external-trigger' if @tag_name == 'navtabs_ee'

        template = ERB.new html
        template.result(binding)
      end

      def html
        <<~NAVTABS
          <div class="navtabs <%= @class %> <%= environment['additional_classes'] %>">
            <div class="navtab-titles" role="tablist">
            <% environment['navtabs-' + navtabs_id].each_with_index do |(title, value), index| %>
              <% slug = title.downcase.strip.gsub(' ', '-').gsub(/[^\\w-]/, '') %>
              <div data-slug="<%= slug %>" data-navtab-id="navtab-<%= navtabs_id %>-<%= index %>" class="navtab-title" role="tab" aria-controls="navtab-id-<%= index %>" tabindex="0">
                <%= title %>
              </div>
            <% end %>
            </div>
            <div class="navtab-contents">
            <% environment['navtabs-' + navtabs_id].each_with_index do |(title, value), index| %>
              <div data-navtab-content="navtab-<%= navtabs_id %>-<%= index %>" class="navtab-content" role="tabpanel" id="navtab-id-<%= index %>" tabindex="0" aria-labelledby="navtab-id-<%= index %>" >
                <%= value %>
              </div>
            <% end %>
            </div>
          </div>
        NAVTABS
      end
    end

    class NavTabBlock < Liquid::Block
      alias render_block render

      def initialize(tag_name, markup, tokens)
        super
        raise SyntaxError, "No toggle name given in #{tag_name} tag" if markup == ''

        @title = markup.strip
      end

      def render(context)
        # Add support for variable titles
        path = @title.split('.')
        # 0 is the page scope, 1 is the local scope
        [0,1].each do |k|
          next unless context.scopes[k]
          ref = context.scopes[k].dig(*path)
          @title = ref if ref
        end

        site = context.registers[:site]
        converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
        environment = context.environments.first

        navtabs_id = environment['navtabs-stack'].last
        environment["navtabs-#{navtabs_id}"][@title] = converter.convert(render_block(context))
      end
    end
  end
end

Liquid::Template.register_tag('navtab', Jekyll::NavTabs::NavTabBlock)
Liquid::Template.register_tag('navtabs', Jekyll::NavTabs::NavTabsBlock)
Liquid::Template.register_tag('navtabs_ee', Jekyll::NavTabs::NavTabsBlock)
