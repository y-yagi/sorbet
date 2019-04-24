# -*- encoding: utf-8 -*-
# stub: nakayoshi_fork 0.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "nakayoshi_fork".freeze
  s.version = "0.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Koichi Sasada".freeze]
  s.date = "2018-04-13"
  s.description = "nakayoshi_fork gem solves CoW friendly problem on MRI 2.2 and later.".freeze
  s.email = ["ko1@atdot.net".freeze]
  s.homepage = "https://github.com/ko1/nakayoshi_fork".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "nakayoshi_fork gem solves CoW friendly problem on MRI 2.2 and later.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
  end
end
