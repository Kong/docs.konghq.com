# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "github-pages-health-check"
  s.version = "0.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["GitHub, Inc."]
  s.date = "2015-03-06"
  s.description = "Checks your GitHub Pages site for commons DNS configuration issues."
  s.email = "support@github.com"
  s.homepage = "https://github.com/github/github-pages-health-check"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.0.14"
  s.summary = "Checks your GitHub Pages site for commons DNS configuration issues"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<net-dns>, ["~> 0.6"])
      s.add_runtime_dependency(%q<public_suffix>, ["~> 1.4"])
      s.add_development_dependency(%q<rspec>, ["~> 3.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<gem-release>, [">= 0"])
    else
      s.add_dependency(%q<net-dns>, ["~> 0.6"])
      s.add_dependency(%q<public_suffix>, ["~> 1.4"])
      s.add_dependency(%q<rspec>, ["~> 3.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<gem-release>, [">= 0"])
    end
  else
    s.add_dependency(%q<net-dns>, ["~> 0.6"])
    s.add_dependency(%q<public_suffix>, ["~> 1.4"])
    s.add_dependency(%q<rspec>, ["~> 3.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<gem-release>, [">= 0"])
  end
end
