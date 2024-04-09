# frozen_string_literal: true

require 'jekyll-generator-single-source'

module Jekyll
  class PluginVersionIs < Jekyll::GeneratorSingleSource::Liquid::Tags::VersionIs
    def initialize(tag_name, markup, options)
      super
      @blocks = []
      push_block('if_plugin_version', markup)
    end

    def parse_condition(markup)
      IfPluginVersionCondition.new(markup)
    end

    class IfPluginVersionCondition < Jekyll::GeneratorSingleSource::Liquid::Tags::VersionIs::IfVersionCondition
      def evaluate(context) # rubocop:disable Metrics/PerceivedComplexity, Metrics/MethodLength, Metrics/CyclomaticComplexity, Metrics/AbcSize
        params = {}
        @left.scan(TAG_ATTRIBUTES) do |key, value|
          params[key.to_sym] = value
        end

        page = context.environments.first['page']

        # Validate that there was at least one check
        unless %i[eq gte lte neq].any? { |k| params.key?(k) }
          ::Jekyll.logger.error "Invalid if_plugin_version usage: #{params.to_json}"
          return true
        end

        # Ideally we'd raise here and require a version for all files, but to reduce
        # breaking changes we'll just return true if there is no version set
        ::Jekyll.logger.debug "Missing version for #{page['path']}" unless page['version']
        return true unless page['version']

        page_version = page['version'].to_s.gsub('-', '.').gsub('.x', '.0')

        begin
          current_version = to_version(context, page_version) # Handle 3.0.x etc
        rescue StandardError => e
          # Again, return true early if we can't parse a version
          ::Jekyll.logger.error "Unable to parse version in #{page['path']} [#{page_version}]: #{e}".red
          return true
        end

        # If there's an exact match, check only that
        if params.key?(:eq)
          versions = params[:eq].split(',').map { |v| to_version(context, v) }
          return false unless versions.any? { |v| v == current_version }
        end

        # If there's a greater than or equal to check, fail if it's lower
        if params.key?(:gte)
          version = to_version(context, params[:gte])
          return false unless current_version >= version
        end

        # If there's a less than or equal to check, fail if it's higher
        if params.key?(:lte)
          version = to_version(context, params[:lte])
          return false unless current_version <= version
        end

        if params.key? :neq
          # If there's a not-equal to check, fail if they are equal
          version = to_version(context, params[:neq])
          return false if current_version == version
        end

        true
      end

      def to_version(context, input)
        # If we were provided with a variable, pull that out of the current scope
        path = input.split('.')
        ref = context.scopes[0].dig(*path)
        input = ref if ref

        # Handle minimum_version check when there is not a minimum version set
        input = '0.0.0' if input.include?('minimum_version')

        input = '999.99.9' if input.include?('maximum_version')

        # Then convert to a Gem::Version for later comparison
        Gem::Version.new(input.gsub(/\.x$/, '.0'))
      end
    end
  end
end

Liquid::Template.register_tag('if_plugin_version', Jekyll::PluginVersionIs)
