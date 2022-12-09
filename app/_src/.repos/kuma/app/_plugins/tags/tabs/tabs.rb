require 'erb'
require 'securerandom'

module Jekyll
  module Tabs
    class TabsBlock < Liquid::Block
      def initialize(tag_name, config, tokens)
        super

        @name, options = config.split(' ', 2)
        @options = options.split(' ').each_with_object({}) do |o, h|
          key, value = o.split('=')
          h[key] = value
        end
      end

      def render(context)
        environment = context.environments.first
        environment['tabs'] ||= {}
        file_path = context.registers[:page]['path']
        environment['tabs'][file_path] ||= {}

        if environment['tabs'][file_path].key? @name
          raise SyntaxError.new("There's already a {% tabs %} block with the name '#{@name}'.")
        end

        environment['tabs'][file_path][@name] ||= {}

        super

        options = @options
        templateFile = File.read(File.expand_path('template.erb', __dir__))
        template = ERB.new(templateFile)
        template.result(binding)
      end
    end

    class TabBlock < Liquid::Block
      alias_method :render_block, :render

      def initialize(tag_name, markup, tokens)
        super

        @name, @tab = markup.split(' ', 2)
      end

      def render(context)
        site = context.registers[:site]
        converter = site.find_converter_instance(::Jekyll::Converters::Markdown)
        file_path = context.registers[:page]['path']

        environment = context.environments.first

        environment['tabs'][file_path][@name] ||= {}
        environment['tabs'][file_path][@name][@tab] = converter.convert(render_block(context))
      end
    end
  end
end

Liquid::Template.register_tag('tab', Jekyll::Tabs::TabBlock)
Liquid::Template.register_tag('tabs', Jekyll::Tabs::TabsBlock)
