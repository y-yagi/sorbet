# -*- encoding: utf-8 -*-
# stub: omniauth-authentiq 0.3.3 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-authentiq".freeze
  s.version = "0.3.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alexandros Keramidas".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-05-24"
  s.description = "Strategy to enable passwordless authentication in OmniAuth via Authentiq.".freeze
  s.email = ["alex@authentiq.com".freeze, "support@authentiq.com".freeze]
  s.homepage = "https://github.com/AuthentiqID/omniauth-authentiq".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Authentiq strategy for OmniAuth".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<jwt>.freeze, [">= 1.5"])
      s.add_runtime_dependency(%q<omniauth-oauth2>.freeze, [">= 1.5"])
    else
      s.add_dependency(%q<jwt>.freeze, [">= 1.5"])
      s.add_dependency(%q<omniauth-oauth2>.freeze, [">= 1.5"])
    end
  else
    s.add_dependency(%q<jwt>.freeze, [">= 1.5"])
    s.add_dependency(%q<omniauth-oauth2>.freeze, [">= 1.5"])
  end
end
