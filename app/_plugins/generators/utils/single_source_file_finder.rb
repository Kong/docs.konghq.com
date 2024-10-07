# frozen_string_literal: true

module Utils
  class SingleSourceFileFinder
    def self.find(file_path:, version:)
      if File.exist?(File.join(file_path, "_#{version}.yml"))
        File.join(file_path, "_#{version}.yml")
      else
        File.join(file_path, '_index.yml')
      end
    end
  end
end
