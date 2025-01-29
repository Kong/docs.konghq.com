# frozen_string_literal: true

require 'erb'
require 'securerandom'

module Jekyll
  module Tabs
    class TabsBlock < Liquid::Block
      def initialize(tag_name, config, tokens)
        super

        @name, options = config.split(' ', 2)
        @options = options.split.each_with_object({}) do |o, h|
          key, value = o.split('=')
          h[key] = value
        end
      end

      def render(context) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
        environment = context.environments.first
        environment['tabs'] ||= {}
        file_path = context.registers[:page]['dir']
        environment['tabs'][file_path] ||= {}

        if environment['tabs'][file_path].key? @name
          raise SyntaxError, "There's already a {% tabs %} block with the name '#{@name}'."
        end

        environment['tabs'][file_path][@name] ||= {}

        super

        options = @options
        template_file = File.read(File.expand_path('template.erb', __dir__))
        template = ERB.new(template_file)
        template.result(binding)
      end
    end

    class TabBlock < Liquid::Block
      alias render_block render

      def initialize(tag_name, markup, tokens)
        super

        @name, @tab = markup.split(' ', 2)
      end

      def render(context) # rubocop:disable Metrics/AbcSize
        site = context.registers[:site]
        converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
        file_path = context.registers[:page]['dir']

        environment = context.environments.first

        environment['tabs'][file_path][@name] ||= {}
        environment['tabs'][file_path][@name][@tab] = converter.convert(render_block(context))
      end
    end
  end
end

Liquid::Template.register_tag('tab', Jekyll::Tabs::TabBlock)
Liquid::Template.register_tag('tabs', Jekyll::Tabs::TabsBlock)
