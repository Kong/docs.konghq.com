# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "rdiscount"
  s.version = "2.1.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Ryan Tomayko", "David Loren Parsons", "Andrew White", "David Foster"]
  s.date = "2013-10-13"
  s.email = "davidfstr@gmail.com"
  s.executables = ["rdiscount"]
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["COPYING"]
  s.files = ["bin/rdiscount", "COPYING", "ext/extconf.rb"]
  s.homepage = "http://dafoster.net/projects/rdiscount/"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new("!= 1.9.2")
  s.rubyforge_project = "wink"
  s.rubygems_version = "2.0.14"
  s.summary = "Fast Implementation of Gruber's Markdown in C"
end
