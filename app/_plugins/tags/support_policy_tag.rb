# frozen_string_literal: true

# Example usage in markdown files:
# ----------------------------------------
# {% support_policy kong_versions_mesh %}
# It will extract metadata from the `versions.yml` file and render a table of all releases with
# their first release and the end of life date.
module Jekyll
  class SupportPolicyTag < Liquid::Tag
    def initialize(tag_name, version_name, tokens)
      super
      @version_name = version_name
    end

    def render(context)
      versions = context.registers[:site].data[@version_name.to_s]
      out = "
| Version  | Latest Patch  | Released Date | End of Full Support |
|:--------:|:-------------:|:-------------:|:-------------------:|\n"
      versions.each do |entry|
        next if entry['label'] == 'unreleased'

        out += "| #{entry['release']} | #{entry['version']} | #{entry['releaseDate']} | #{entry['endOfLifeDate']} |\n"
      end
      out
    end
  end
end
Liquid::Template.register_tag('support_policy', Jekyll::SupportPolicyTag)
