module Jekyll
  module Tags
    class FeatureFlagBlock < Liquid::Block
      SYNTAX = /availability="(?<availability>[\w-]+)"(?:\s+version="(?<version>[^"]+)")?/i

      ICONS = {
        'enterprise' => '🏢',
        'cloud' => '☁️',
        'oss' => '🌱',
        'default' => '🚩'
      }

      def initialize(tag_name, markup, tokens)
        super
        unless markup =~ SYNTAX
          raise SyntaxError, "Invalid syntax for featureflag. Usage: {% featureflag availability=\"enterprise\" version=\"3.5\" %}"
        end
      
        @availability = Regexp.last_match[:availability]
        @version = Regexp.last_match[:version]
      end

      def render(context)
        content = super.strip

        # Clean version for human-readable usage
        clean_version = @version&.gsub(/\+|\.x/, '')
        content.gsub!("{version}", clean_version.to_s) if clean_version

        classes = ["feature-flag", "availability-#{@availability}"]
        version_info = @version ? "<span class=\"version\">(#{@version})</span>" : ""
        availability_label = @availability.capitalize.gsub('-', ' ')
        icon = ICONS.fetch(@availability, ICONS['default'])

        "<div class=\"#{classes.join(' ')}\"><span class=\"icon\">#{icon}</span> <strong>#{availability_label}</strong>#{version_info}: #{content}</div>"
      end
    end
  end
end

Liquid::Template.register_tag('featureflag', Jekyll::Tags::FeatureFlagBlock)