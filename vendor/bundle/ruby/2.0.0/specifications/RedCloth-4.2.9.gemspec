# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "RedCloth"
  s.version = "4.2.9"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Jason Garber", "why the lucky stiff", "Ola Bini"]
  s.date = "2011-11-27"
  s.description = "Textile parser for Ruby."
  s.email = "redcloth-upwards@rubyforge.org"
  s.executables = ["redcloth"]
  s.extensions = ["ext/redcloth_scan/extconf.rb"]
  s.extra_rdoc_files = ["README.rdoc", "COPYING", "CHANGELOG"]
  s.files = ["bin/redcloth", "README.rdoc", "COPYING", "CHANGELOG", "ext/redcloth_scan/extconf.rb"]
  s.homepage = "http://redcloth.org"
  s.rdoc_options = ["--charset=UTF-8", "--line-numbers", "--inline-source", "--title", "RedCloth", "--main", "README.rdoc"]
  s.require_paths = ["lib", "lib/case_sensitive_require", "ext"]
  s.rubyforge_project = "redcloth"
  s.rubygems_version = "2.0.14"
  s.summary = "RedCloth-4.2.9"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>, ["~> 1.0.10"])
      s.add_development_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_development_dependency(%q<rspec>, ["~> 2.4"])
      s.add_development_dependency(%q<diff-lcs>, ["~> 1.1.2"])
      s.add_development_dependency(%q<rvm>, ["~> 1.2.6"])
      s.add_development_dependency(%q<rake-compiler>, ["~> 0.7.1"])
    else
      s.add_dependency(%q<bundler>, ["~> 1.0.10"])
      s.add_dependency(%q<rake>, ["~> 0.8.7"])
      s.add_dependency(%q<rspec>, ["~> 2.4"])
      s.add_dependency(%q<diff-lcs>, ["~> 1.1.2"])
      s.add_dependency(%q<rvm>, ["~> 1.2.6"])
      s.add_dependency(%q<rake-compiler>, ["~> 0.7.1"])
    end
  else
    s.add_dependency(%q<bundler>, ["~> 1.0.10"])
    s.add_dependency(%q<rake>, ["~> 0.8.7"])
    s.add_dependency(%q<rspec>, ["~> 2.4"])
    s.add_dependency(%q<diff-lcs>, ["~> 1.1.2"])
    s.add_dependency(%q<rvm>, ["~> 1.2.6"])
    s.add_dependency(%q<rake-compiler>, ["~> 0.7.1"])
  end
end
