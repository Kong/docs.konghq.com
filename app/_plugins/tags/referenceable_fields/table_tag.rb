# frozen_string_literal: true

require 'json'

module Jekyll
  class ReferenceableFieldsTable < Liquid::Tag
    def render(context) # rubocop:disable Metrics/AbcSize
      environment = context.environments.first

      super

      version = context.environments.first['page']['release']
      hub = context.registers[:site].data['ssg_hub']

      @referenceable_fields = ReferenceableFields.run(version:, hub:)

      template_file = File.read(File.expand_path('table_template.erb', __dir__))
      template = ERB.new(template_file)
      template.result(binding)
    end
  end

  class ReferenceableFields
    FILES_PATH = 'app/_src/.repos/kong-plugins/data/referenceable_fields/'

    def self.run(version:, hub:)
      new(version:, hub:).run
    end

    def initialize(version:, hub:)
      @version = version
      @hub = hub
    end

    def run
      referenceable_fields.each_with_object({}) do |(slug, fields), result|
        page = plugin_page(slug)

        next unless page

        result[slug] = [page.data['name'], fields]
      end
    end

    def referenceable_fields
      @referenceable_fields ||= JSON.parse(
        File.read(File.join(FILES_PATH, "#{@version}.json"))
      )
    end

    def plugin_page(slug)
      @hub.detect { |plugin| plugin.data['extn_slug'] == slug }
    end
  end
end

Liquid::Template.register_tag('referenceable_fields_table', Jekyll::ReferenceableFieldsTable)
