# frozen_string_literal: true

require 'json'

module Jekyll
  class PluginsPriorityTable < Liquid::Tag
    PRIORITIES_PATH = 'app/_src/.repos/kong-plugins/data/priorities'

    def initialize(tag_name, type, tokens)
      super

      @type = type.strip
    end

    def render(context)
      @context = context
      @site = context.registers[:site]
      @page = context.environments.first['page']

      Liquid::Template
        .parse(template)
        .render(
          { 'page' => @page,
            'include' => { 'plugins' => plugins, 'type' => @type, 'correlation_id' => correlation_id } },
          { registers: context.registers }
        )
    end

    private

    def correlation_id
      if type == 'oss'
        oss_priority = plugins['correlation-id']
        free_priority = JSON.parse(File.read("#{PRIORITIES_PATH}/ee/#{version}.json"))['correlation-id']
      else
        free_priority = plugins['correlation-id']
        oss_priority = JSON.parse(File.read("#{PRIORITIES_PATH}/oss/#{version}.json"))['correlation-id']
      end
      { 'free' => free_priority, 'oss' => oss_priority }
    end

    def plugins
      @plugins ||= JSON.parse(File.read("#{PRIORITIES_PATH}/#{type}/#{version}.json"))
    end

    def template
      @template ||= File.read(File.expand_path('app/_includes/plugins/priority_table.html'))
    end

    def version
      @version ||= if @page['release']
                     @page['release'].value
                   else
                     latest_release
                   end
    end

    def type
      case @type
      when 'oss'
        'oss'
      when 'enterprise'
        'ee'
      end
    end

    def latest_release
      @latest_release ||= Jekyll::GeneratorSingleSource::Product::Edition
                          .new(edition: 'gateway', site: @site)
                          .latest_release
                          .value
    end
  end
end

Liquid::Template.register_tag('plugins_priority_table', Jekyll::PluginsPriorityTable)
