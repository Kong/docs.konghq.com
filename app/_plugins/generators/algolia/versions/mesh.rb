# frozen_string_literal: true

module Jekyll
  module Algolia
    module Versions
      class Mesh
        def self.indexed_version(version)
          page_version = Gem::Version.new(version)

          if page_version <= Gem::Version.new('2.3.x')
            '2.3.x'
          elsif page_version <= Gem::Version.new('2.4.x')
            '2.4.x'
          else
            'latest'
          end
        end
      end
    end
  end
end
