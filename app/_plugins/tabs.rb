module Jekyll
  class Tabs < Liquid::Block

    Tab = Struct.new(:title, :attachment)

    def initialize(tag_name, markup, options)
      super
      @tabs = []
    end

    def nodelist
      @tabs.map(&:attachment)
    end

    def parse(tokens)
      body = Liquid::BlockBody.new
      while parse_body(body, tokens)
        body = @tabs.last.attachment
      end
    end

    def unknown_tag(tag, markup, tokens)
      if 'tab'.freeze == tag
        @tabs << Tab.new(markup, Liquid::BlockBody.new)
      else
        super
      end
    end

    def render(context)
      output = []
      context.stack do
        @tabs.each do |tab|
          output << "**".freeze << tab.title.strip << "**\n\n".freeze <<
            tab.attachment.render(context) << "\n\n".freeze
        end
      end
      output.join
    end
  end
end

Liquid::Template.register_tag('tabs'.freeze, Jekyll::Tabs)
