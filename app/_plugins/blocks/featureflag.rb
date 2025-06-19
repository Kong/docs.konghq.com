# frozen_string_literal: true

module Jekyll
  module Tags
    class FeatureFlagBlock < Liquid::Block
      SYNTAX = /availability="(?<availability>[\w-]+)"(?:\s+version="(?<version>[^"]+)")?/i

      ICONS = {
        'enterprise' => '🏢',
        'cloud' => '☁️',
        'oss' => '🌱',
        'default' => '🚩'
      }.freeze

      def initialize(tag_name, markup, tokens)
        super
        if markup =~ SYNTAX
          @availability = Regexp.last_match[:availability]
          @version = Regexp.last_match[:version]
        else
          raise SyntaxError,
                'Invalid syntax for featureflag. Usage: {% featureflag availability="enterprise" version="3.5" %}'
        end
      end

      def render(context)
        build_html(clean_content(super.strip))
      end

      private

      def clean_content(content)
        version = @version&.gsub(/\+|\.x/, '')
        version ? content.gsub('{version}', version) : content
      end

      def build_html(content)
        classes = ['feature-flag', "availability-#{@availability}"]
        version_info = @version ? "<span class='version'>(#{@version})</span>" : ''
        availability_label = @availability.capitalize.tr('-', ' ')
        icon = ICONS.fetch(@availability, ICONS['default'])

        <<~HTML.chomp
          <div class='#{classes.join(' ')}'>
            <span class='icon'>#{icon}</span>
            <strong>#{availability_label}</strong>#{version_info}: #{content}
          </div>
        HTML
      end
    end
  end
end

Liquid::Template.register_tag('featureflag', Jekyll::Tags::FeatureFlagBlock)
