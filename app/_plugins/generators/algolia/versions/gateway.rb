# frozen_string_literal: true

module Jekyll
  module Algolia
    module Versions
      class Gateway
        def self.indexed_version(version)
          page_version = Gem::Version.new(version)

          if page_version <= Gem::Version.new('2.8.x')
            '2.8.x'
          elsif page_version <= Gem::Version.new('3.4.x')
            '3.4.x'
          elsif page_version <= Gem::Version.new('3.5.x')
            '3.5.x'
          else
            'latest'
          end
        end
      end
    end
  end
end
