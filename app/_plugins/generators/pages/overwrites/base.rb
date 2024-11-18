# frozen_string_literal: true

module Jekyll
  module Pages
    module Overwrites
      class Base
        def self.make_for(site:, page:)
          # cosider only konnect and contributing,
          # the rest of the products are now single-sourced and we aren't
          # translating pre single-sourced versions
          if %w[konnect contributing].include?(page.url.split('/')[1])
            WithNavFile.new(site:, page:)
          else
            WithoutNavFile.new(site:, page:)
          end
        end

        def initialize(site:, page:)
          @site = site
          @page = page
          @data = {}
        end

        def process! # rubocop:disable Metrics/AbcSize,Metrics/MethodLength
          if i18n_file.exists_in_locale?
            content = File.read(file_path)
            if content =~ Jekyll::Document::YAML_FRONT_MATTER_REGEXP
              content = Regexp.last_match.post_match
              @data = SafeYAML.load(Regexp.last_match(1))
            end

            @page.content = content
            @page.data.merge!(@data)
            @page.data['locale'] = @site.config['locale']
            @page.data['full_file_path_in_locale'] = i18n_file.full_file_path_in_locale

            set_i18n_data
          else
            set_missing_translation_data
          end
        end

        private

        def i18n_file
          @i18n_file ||= Jekyll::GeneratorSingleSource::I18nFile.new(
            file: @page.path,
            src_path: '',
            locale: @site.config['locale'],
            site: @site
          )
        end

        def edition
          @edition ||= @page.url.split('/')[1]
        end

        def set_i18n_data; end
      end
    end
  end
end
