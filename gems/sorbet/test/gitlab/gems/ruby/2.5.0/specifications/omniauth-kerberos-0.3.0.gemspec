# -*- encoding: utf-8 -*-
# stub: omniauth-kerberos 0.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-kerberos".freeze
  s.version = "0.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jan Graichen".freeze]
  s.date = "2015-06-29"
  s.description = "An OmniAuth strategy for Kerberos.".freeze
  s.email = ["jan.graichen@altimos.de".freeze]
  s.homepage = "https://github.com/jgraichen/omniauth-kerberos".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "An OmniAuth strategy for Kerberos.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<timfel-krb5-auth>.freeze, ["~> 0.8"])
      s.add_runtime_dependency(%q<omniauth-multipassword>.freeze, [">= 0"])
    else
      s.add_dependency(%q<timfel-krb5-auth>.freeze, ["~> 0.8"])
      s.add_dependency(%q<omniauth-multipassword>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<timfel-krb5-auth>.freeze, ["~> 0.8"])
    s.add_dependency(%q<omniauth-multipassword>.freeze, [">= 0"])
  end
end
