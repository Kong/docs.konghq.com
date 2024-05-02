# frozen_string_literal: true

module Jekyll
  class TranslateTag < Liquid::Tag
    def initialize(tag_name, markup, tokens)
      super

      @translation_key, *@params = markup.strip.split(/\s+(?=(?:[^"]|"[^"]*")*$)/)
      @params_hash = {}
      @params.each do |param|
        key, value = param.split('=')
        @params_hash[key.strip.to_sym] = value
      end
    end

    def render(context) # rubocop:disable Metrics/MethodLength
      locale = context.registers[:site].config['locale']

      # Render the parameter values with the Liquid context
      rendered_params = {}
      @params_hash.each do |key, value|
        rendered_value = if value.start_with?('"') && value.end_with?('"')
                           value[1..-2] # Remove surrounding quotes from string values
                         else
                           Liquid::VariableLookup.new(value).evaluate(context)
                         end
        rendered_params[key] = rendered_value
      end

      # Render the translation with the rendered parameters
      I18n.t(@translation_key, locale:, **rendered_params)
    end
  end
end

Liquid::Template.register_tag('t', Jekyll::TranslateTag)
