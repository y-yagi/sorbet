# -*- encoding: utf-8 -*-
# stub: re2 1.1.1 ruby lib
# stub: ext/re2/extconf.rb

Gem::Specification.new do |s|
  s.name = "re2".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Paul Mucur".freeze]
  s.date = "2017-07-24"
  s.description = "Ruby bindings to re2, \"an efficient, principled regular expression library\".".freeze
  s.email = "ruby.re2@librelist.com".freeze
  s.extensions = ["ext/re2/extconf.rb".freeze]
  s.files = ["ext/re2/extconf.rb".freeze]
  s.homepage = "https://github.com/mudge/re2".freeze
  s.licenses = ["BSD-3-Clause".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Ruby bindings to re2.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.2"])
    else
      s.add_dependency(%q<rake-compiler>.freeze, ["~> 0.9"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
    end
  else
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 0.9"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.2"])
  end
end
