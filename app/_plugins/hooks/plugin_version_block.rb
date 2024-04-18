# frozen_string_literal: true

Jekyll::Hooks.register :pages, :pre_render do |page|
  # Also allow for a newline after endif_version when in a table
  # strip extra new lines
  page.content = page.content.gsub(/\|\s*\n\n\s*{% if_plugin_version /, "|\n{% if_plugin_version ")
  page.content = page.content.gsub(/\|\s*\n{% endif_plugin_version %}\n+\|/, "|\n{% endif_plugin_version -%}\n|")
  page.content = page.content.gsub(/\|\s*\n{% endif_plugin_version %}\n+\s*{% if_plugin_version (.*) %}\n/) do |_match|
    "|\n{% endif_plugin_version -%}\n{% if_plugin_version #{Regexp.last_match(1)} -%}\n"
  end
  page.content = page.content.gsub(/\|\s*\n+{% if_plugin_version (.*) %}\n/) do |_match|
    "|\n{% if_plugin_version #{Regexp.last_match(1)} -%}\n"
  end
end
