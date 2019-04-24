# -*- encoding: utf-8 -*-
# stub: omniauth-multipassword 0.4.2 ruby lib

Gem::Specification.new do |s|
  s.name = "omniauth-multipassword".freeze
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jan Graichen".freeze]
  s.date = "2015-05-18"
  s.description = "A OmniAuth strategy to authenticate using different passwort strategies.".freeze
  s.email = ["jg@altimos.de".freeze]
  s.homepage = "https://github.com/jgraichen/omniauth-multipassword".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "A OmniAuth strategy to authenticate using different passwort strategies.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<omniauth>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<omniauth>.freeze, ["~> 1.0"])
  end
end
