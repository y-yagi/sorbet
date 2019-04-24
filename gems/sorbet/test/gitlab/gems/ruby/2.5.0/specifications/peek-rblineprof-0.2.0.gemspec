# -*- encoding: utf-8 -*-
# stub: peek-rblineprof 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "peek-rblineprof".freeze
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Garrett Bjerkhoel".freeze]
  s.date = "2017-01-12"
  s.description = "Peek into how much each line of your Rails application takes throughout a request.".freeze
  s.email = ["me@garrettbjerkhoel.com".freeze]
  s.homepage = "https://github.com/peek/peek-rblineprof".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Peek into how much each line of your Rails application takes throughout a request.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<peek>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rblineprof>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<peek>.freeze, [">= 0"])
      s.add_dependency(%q<rblineprof>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<peek>.freeze, [">= 0"])
    s.add_dependency(%q<rblineprof>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
