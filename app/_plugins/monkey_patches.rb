# frozen_string_literal: true

require 'jekyll'
require 'jekyll-include-cache'

module Jekyll
  module Tags
    # Monkey-patch liquid's include tag so that it looks for the include in the
    # site's locale and fallback to the english version if it does not exist.
    # Used by {% include_cached %}
    class IncludeTag
      def locate_include_file(context, file, safe) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
        site = context.registers[:site]
        page = context.registers[:page]

        includes_dirs = tag_includes_dirs(context)
        includes_dirs.each do |dir|
          if site.config['locale'] != I18n.default_locale.to_s && page && !page['translation_fallback']
            # japanese
            translated_includes_dir = File.expand_path(File.join(site.config['translated_content_path'], '_includes'),
                                                       site.source)
            if site.config['translated_content_path'] && Dir.exist?(translated_includes_dir)
              path = File.join(translated_includes_dir, file)
              return path if File.exist?(path)
            end

          end
          path = PathManager.join(dir, file)
          return path if valid_include_file?(path, dir.to_s, safe)
        end
        raise IOError, could_not_locate_message(file, includes_dirs, safe)
      end
    end

    # Used by {% include %}
    class OptimizedIncludeTag
      def locate_include_file(file) # rubocop:disable Metrics/MethodLength,Metrics/AbcSize
        @site.includes_load_paths.each do |dir|
          unless @site.config['locale'] == I18n.default_locale.to_s
            # japanese
            translated_includes_dir = File.expand_path(File.join(@site.config['translated_content_path'], '_includes'),
                                                       @site.source)
            if @site.config['translated_content_path'] && Dir.exist?(translated_includes_dir)
              path = File.join(translated_includes_dir, file)
              return Inclusion.new(@site, translated_includes_dir, file) if File.exist?(path)
            end
          end

          path = PathManager.join(dir, file)
          return Inclusion.new(@site, dir, file) if valid_include_file?(path, dir)
        end
        raise IOError, could_not_locate_message(file, @site.includes_load_paths, @site.safe)
      end
    end
  end
end

module JekyllIncludeCache
  # Monkey-patch jekyll-include-cache include_cached tag so that it takes into account the
  # page's locale
  class Tag
    def render(context) # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
      site = context.registers[:site]
      page = context.registers[:page]
      path = path(context)

      params = @params ? parse_params(context) : {}
      # This is needed for the sidenav mainly,
      # we for a set of docs of the same version, we could
      # renderer it either in the locale or in default_locale
      params.merge!('locale' => page['locale'] || site.config['locale'])

      key = key(path, params)
      return unless path

      if JekyllIncludeCache.cache.key?(key)
        Jekyll.logger.debug 'Include cache hit', path
        JekyllIncludeCache.cache[key]
      else
        Jekyll.logger.debug 'Include cache miss:', path
        JekyllIncludeCache.cache[key] = super
      end
    end
  end
end
