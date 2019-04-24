# -*- encoding: utf-8 -*-
# stub: peek-pg 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "peek-pg".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Garrett Bjerkhoel".freeze]
  s.date = "2017-01-12"
  s.description = "Take a\u00A0peek into the Postgres queries made during your application's requests.".freeze
  s.email = ["me@garrettbjerkhoel.com".freeze]
  s.homepage = "https://github.com/peek/peek-pg".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Take a peek into the Postgres queries made during your application's requests.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<peek>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<pg>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<concurrent-ruby-ext>.freeze, [">= 0"])
    else
      s.add_dependency(%q<peek>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
      s.add_dependency(%q<concurrent-ruby-ext>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<peek>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<concurrent-ruby>.freeze, [">= 0"])
    s.add_dependency(%q<concurrent-ruby-ext>.freeze, [">= 0"])
  end
end
