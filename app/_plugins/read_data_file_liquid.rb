# frozen_string_literal: true

# via https://gist.github.com/dgopstein/7fcb514d163f7b090edd5a98b9f3f9a7
# Treat every _data file as liquid.
# This allows us to include YAML files in other YAML files.

require 'tmpdir'

module Jekyll
  # Monkey patch Jekyll::DataReader::read_data_file with our own implementation
  class DataReader
    def read_data_file_with_liquid(path) # rubocop:disable Metrics/MethodLength, Metrics/AbcSize
      dir = File.dirname(path)
      filename = File.basename(path)

      # If there are multiple sites assume we're
      # the most recent since we're just starting up
      site = Jekyll.sites.last

      content = if dir.start_with?(site.source)
                  File.read(site.in_source_dir(dir, filename))
                else
                  File.read(File.join(dir, filename))
                end
      template = Liquid::Template.parse(content)

      context = Liquid::Context.new({}, {}, { site: })
      rendered = template.render(context)

      # Write the post-liquid-rendered file to a temporary file.
      # read_data_file parses the name of the file to use as its
      # variable name in site.data so it's important to make the
      # temp file name match the original file name.
      Dir.mktmpdir do |tmp_dir|
        tmp_path = File.join(tmp_dir, filename)
        File.write(tmp_path, rendered)
        read_data_file_without_liquid(tmp_path)
      end
    rescue StandardError => e
      Jekyll.logger.warn(
        "[Liquid Data] Error parsing data files for Liquid content at file #{path}: #{e.message}"
      )
    end

    # Make our function overwrite the existing read_data_file function
    # but keep the ability to still call back to the original
    alias read_data_file_without_liquid read_data_file
    alias read_data_file read_data_file_with_liquid
  end
end

# Only include the given file one time (in this call tree)
# Useful for files that include files that include the original file
module Jekyll
  module Tags
    class IncludeRelativeOnceTag < IncludeRelativeTag
      # Create a flag that indicates we're already 1 level
      # deep in the inclusion, and don't go any farther down
      SENTINEL = 'included_relative_once'

      def render(context)
        context.stack do
          unless context[SENTINEL]
            context[SENTINEL] = true
            super
          end
        end
      end
    end
  end
end

Liquid::Template.register_tag('include_relative_once', Jekyll::Tags::IncludeRelativeOnceTag)
