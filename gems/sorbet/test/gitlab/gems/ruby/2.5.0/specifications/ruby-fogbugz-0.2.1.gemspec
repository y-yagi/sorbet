# -*- encoding: utf-8 -*-
# stub: ruby-fogbugz 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-fogbugz".freeze
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Simon H\u00F8rup Eskildsen".freeze, "Jared Szechy".freeze]
  s.date = "2015-09-15"
  s.description = "A simple Ruby wrapper for the Fogbugz XML API".freeze
  s.email = ["sirup@sirupsen.com".freeze, "jared.szechy@gmail.com".freeze]
  s.homepage = "https://github.com/firmafon/ruby-fogbugz".freeze
  s.licenses = ["MIT".freeze]
  s.rubyforge_project = "ruby-fogbugz".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Ruby wrapper for the Fogbugz API".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<crack>.freeze, ["~> 0.4"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.1"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.8"])
      s.add_development_dependency(%q<mocha>.freeze, ["~> 1.1"])
      s.add_development_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
    else
      s.add_dependency(%q<crack>.freeze, ["~> 0.4"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.1"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.8"])
      s.add_dependency(%q<mocha>.freeze, ["~> 1.1"])
      s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<crack>.freeze, ["~> 0.4"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.1"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.8"])
    s.add_dependency(%q<mocha>.freeze, ["~> 1.1"])
    s.add_dependency(%q<codeclimate-test-reporter>.freeze, [">= 0"])
  end
end
