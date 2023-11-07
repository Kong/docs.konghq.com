# frozen_string_literal: true

module Jekyll
  module Algolia
    module Versions
      class KIC
        def self.indexed_version(version)
          page_version = Gem::Version.new(version)

          if page_version <= Gem::Version.new('2.5.x')
            '2.5.x'
          elsif page_version <= Gem::Version.new('2.12.x')
            '2.12.x'
          elsif page_version <= Gem::Version.new('3.0.x')
            '3.0.x'
          else
            'latest'
          end
        end
      end
    end
  end
end
