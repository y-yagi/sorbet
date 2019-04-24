# -*- encoding: utf-8 -*-
# stub: doorkeeper-openid_connect 1.5.5 ruby lib

Gem::Specification.new do |s|
  s.name = "doorkeeper-openid_connect".freeze
  s.version = "1.5.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sam Dengler".freeze, "Markus Koller".freeze]
  s.date = "2019-03-03"
  s.description = "OpenID Connect extension for Doorkeeper.".freeze
  s.email = ["sam.dengler@playonsports.com".freeze, "markus-koller@gmx.ch".freeze]
  s.homepage = "https://github.com/doorkeeper-gem/doorkeeper-openid_connect".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "OpenID Connect extension for Doorkeeper.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<doorkeeper>.freeze, [">= 4.3"])
      s.add_runtime_dependency(%q<json-jwt>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_development_dependency(%q<factory_bot>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.3.6"])
      s.add_development_dependency(%q<pry-byebug>.freeze, [">= 0"])
      s.add_development_dependency(%q<conventional-changelog>.freeze, ["~> 1.2"])
    else
      s.add_dependency(%q<doorkeeper>.freeze, [">= 4.3"])
      s.add_dependency(%q<json-jwt>.freeze, ["~> 1.6"])
      s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
      s.add_dependency(%q<factory_bot>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.6"])
      s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
      s.add_dependency(%q<conventional-changelog>.freeze, ["~> 1.2"])
    end
  else
    s.add_dependency(%q<doorkeeper>.freeze, [">= 4.3"])
    s.add_dependency(%q<json-jwt>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rspec-rails>.freeze, [">= 0"])
    s.add_dependency(%q<factory_bot>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.6"])
    s.add_dependency(%q<pry-byebug>.freeze, [">= 0"])
    s.add_dependency(%q<conventional-changelog>.freeze, ["~> 1.2"])
  end
end
