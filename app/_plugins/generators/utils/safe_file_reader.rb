# frozen_string_literal: true

module Utils
  class SafeFileReader
    def self.read(file_name:, source_path:)
      file_path = File.expand_path(file_name, source_path)
      return '' unless File.exist?(file_path)

      FrontmatterParser.new(File.read(file_path)).content
    end
  end
end
