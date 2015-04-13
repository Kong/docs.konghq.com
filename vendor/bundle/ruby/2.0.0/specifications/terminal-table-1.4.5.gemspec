# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "terminal-table"
  s.version = "1.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["TJ Holowaychuk", "Scott J. Goldman"]
  s.date = "2012-03-14"
  s.description = "Simple, feature rich ascii table generation library"
  s.email = "tj@vision-media.ca"
  s.extra_rdoc_files = ["README.rdoc", "lib/terminal-table.rb", "lib/terminal-table/cell.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/import.rb", "lib/terminal-table/table.rb", "lib/terminal-table/version.rb", "lib/terminal-table/row.rb", "lib/terminal-table/separator.rb", "lib/terminal-table/style.rb", "lib/terminal-table/table_helper.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.files = ["README.rdoc", "lib/terminal-table.rb", "lib/terminal-table/cell.rb", "lib/terminal-table/core_ext.rb", "lib/terminal-table/import.rb", "lib/terminal-table/table.rb", "lib/terminal-table/version.rb", "lib/terminal-table/row.rb", "lib/terminal-table/separator.rb", "lib/terminal-table/style.rb", "lib/terminal-table/table_helper.rb", "tasks/docs.rake", "tasks/gemspec.rake", "tasks/spec.rake"]
  s.homepage = "http://github.com/visionmedia/terminal-table"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Terminal-table", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("> 0.0.0")
  s.rubyforge_project = "terminal-table"
  s.rubygems_version = "2.0.14"
  s.summary = "Simple, feature rich ascii table generation library"
end
