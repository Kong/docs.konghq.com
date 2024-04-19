# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/hash'
require 'jekyll'

class LocalizedDataReader
  def initialize(site, content_path)
    @site = site
    @content_path = content_path
    @data = {}
  end

  def read(dir)
    base = File.expand_path(dir, File.join(@site.source, @content_path))

    return @data unless Dir.exist?(base)

    read_data_to(base, @data)
    @data
  end

  def read_data_to(dir, data) # rubocop:disable Metrics/MethodLength
    entries = Dir.chdir(dir) do
      Dir['*.{yaml,yml,json}'] + Dir['*'].select { |fn| File.directory?(fn) }
    end

    entries.each do |entry|
      path = File.expand_path(entry, dir)

      if File.directory?(path)
        read_data_to(path, data[entry] = {})
      else
        key = File.basename(entry, '.*')
        data[key] = SafeYAML.load_file(path)
      end
    end
  end
end

Jekyll::Hooks.register :site, :post_read do |site|
  if site.config['locale'] != I18n.default_locale.to_s && site.config['translated_content_path']
    default_data = site.data

    localized_data = LocalizedDataReader.new(
      site,
      site.config['translated_content_path']
    ).read('_data')

    site.data = Jekyll::Utils.deep_merge_hashes(default_data, localized_data)
  end
end

Jekyll::Hooks.register :site, :after_init do |site|
  I18n.locale = site.config['locale']

  if I18n.locale.to_s != I18n.default_locale.to_s && ENV['TRANSLATED_CONTENT_PATH']
    translated_content_path = File.join(ENV['TRANSLATED_CONTENT_PATH'], site.config['locale'], 'app')
    config = Jekyll::Utils.deep_merge_hashes(site.config, translated_content_path:)

    # Prevent BingSiteAuth and google-verification pages from being generated,
    # we discussed this with the web team and we'll add those if they become needed.
    # Unfortunately, deep_merge_hashes doesn't handle arrays well,
    # so we need to add these manually.
    config['exclude'].push('BingSiteAuth.xml', 'google275fdcdba19266f5.html', 'googled7a99b1cae8a33d6.html')

    site.config = Jekyll.configuration(config)

    locale_folder = File.join('../config/locales', '**', '*.yml')
    I18n.load_path += Dir[File.join(File.expand_path(site.config['translated_content_path'], site.source),
                                    locale_folder)]
  end
end
