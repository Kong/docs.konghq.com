# frozen_string_literal: true

# Generates a named anchor and wrapping tag from a string.

module Jekyll
  class VersionIs < Liquid::Block
    def initialize(tag_name, markup, tokens)
      @tag = markup

      @params = {}
      markup.scan(Liquid::TagAttributes) do |key, value|
        @params[key.to_sym] = value
      end
      super
    end

    def render(context) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
      contents = super

      current_version = to_version(context.environments.first['page']['kong_version'])

      # If there's an exact match, check only that
      if @params.key?(:eq)
        version = to_version(@params[:eq])
        return '' unless current_version == version
      end

      # If there's a greater than or equal to check, fail if it's lower
      if @params.key?(:gte)
        version = to_version(@params[:gte])
        return '' unless current_version >= version
      end

      # If there's a less than or equal to heck, fail if it's higher
      if @params.key?(:lte)
        version = to_version(@params[:lte])
        return '' unless current_version <= version
      end

      # Remove the leading and trailing whitespace and return
      # We can't use .strip as that removes all leading whitespace,
      # including indentation
      contents.sub(/^\n/, '').sub(/\n$/, '')
    end

    def to_version(input)
      Gem::Version.new(input.gsub(/\.x$/, '.0'))
    end
  end
end

Liquid::Template.register_tag('if_version', Jekyll::VersionIs)

Jekyll::Hooks.register :pages, :pre_render do |page|
  # Replace double line breaks when using if_version when
  # combined with <pre> blocks. This is usually in code samples
  page.content = page.content.gsub(/\n(\s*{% if_version)/, '\1')

  # Also allow for a newline after endif_version when in a table
  page.content = page.content.gsub("{% endif_version %}\n\n|", "{% endif_version %}\n|")
end
