# frozen_string_literal: true

require 'active_support'
require 'active_support/core_ext/hash'
require 'jekyll'

Jekyll::Hooks.register :site, :after_init do |site|
  I18n.locale = site.config['locale']

  if I18n.locale != I18n.default_locale.to_s && site.config['translated_content_path']
    locale_folder = File.join('../config/locales', '**', '*.yml')
    I18n.load_path += Dir[File.join(File.expand_path(site.config['translated_content_path'], site.source),
                                    locale_folder)]
  end
end
