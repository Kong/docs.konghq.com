# frozen_string_literal: true

module Jekyll
  module Algolia
    module Versions
      class Mesh
        def self.indexed_version(version)
          if Gem::Version.correct?(version)
            version
          else
            version == 'dev' ? 'dev' : 'latest'
          end
        end
      end
    end
  end
end
