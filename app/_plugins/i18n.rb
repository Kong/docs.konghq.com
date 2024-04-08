# frozen_string_literal: true

require 'i18n'
require 'i18n/backend/fallbacks'

I18n.enforce_available_locales = false
I18n::Backend::Simple.include I18n::Backend::Fallbacks
I18n.load_path += Dir["#{File.expand_path('config/locales')}/**/*.yml"]
I18n.fallbacks = ['en']
I18n.default_locale = 'en'
