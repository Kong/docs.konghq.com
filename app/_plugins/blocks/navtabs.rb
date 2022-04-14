=begin
Example usage in markdown files:
----------------------------------------
{% navtabs custom-class %}
{% navtab With a database %}

{{ plugin_config_for_service_with_db }}

{% endnavtab %}
{% navtab Without a database %}

Configure this plugin on a [Service](/latest/admin-api/#service-object) by
adding this section do your declarative configuration file:

``` yaml
plugins:
- name: {{page.params.name}}
  service: {service}
  {{ config_required_fields_yaml }}
```
{% endnavtab %}
{% endnavtabs %}
----------------------------------------

`navtabs` - tabs container
`custom-class` - optional parameter for class added to navtabs container for further customization
`navtab title` - specifies single tab with its title

=end

require 'erb'
require 'securerandom'

module Jekyll
  module NavTabs
    class NavTabsBlock < Liquid::Block
      def initialize(tag_name, markup, tokens)
        super
        @class = markup.strip
      end

      def render(context)
        navtabs_id = SecureRandom.uuid
        environment = context.environments.first
        environment['navtabs-' + navtabs_id] = {}
        environment['navtabs-stack'] ||= []

        environment['navtabs-stack'].push(navtabs_id)
        super
        environment['navtabs-stack'].pop

        template = ERB.new get_template
        template.result(binding)
      end

      def get_template
        <<-EOF
<div class="navtabs <%= @class %>">
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
        EOF
      end
    end

    class NavTabBlock < Liquid::Block
      alias_method :render_block, :render

      def initialize(tag_name, markup, tokens)
        super
        if markup == ""
          raise SyntaxError.new("No toggle name given in #{tag_name} tag")
        end
        @title = markup.strip
      end

      def render(context)
        site = context.registers[:site]
        converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
        environment = context.environments.first

        navtabs_id = environment['navtabs-stack'].last
        environment['navtabs-' + navtabs_id][@title] = converter.convert(render_block(context))
      end
    end
  end
end

Liquid::Template.register_tag("navtab", Jekyll::NavTabs::NavTabBlock)
Liquid::Template.register_tag("navtabs", Jekyll::NavTabs::NavTabsBlock)
