# -*- encoding: utf-8 -*-
# stub: gitlab_omniauth-ldap 2.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "gitlab_omniauth-ldap".freeze
  s.version = "2.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ping Yu".freeze]
  s.date = "2019-02-22"
  s.description = "A LDAP strategy for OmniAuth.".freeze
  s.email = ["ping@intridea.com".freeze]
  s.homepage = "https://gitlab.com/gitlab-org/omniauth-ldap".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "A LDAP strategy for OmniAuth.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<omniauth>.freeze, ["~> 1.3"])
      s.add_runtime_dependency(%q<net-ldap>.freeze, ["~> 0.16"])
      s.add_runtime_dependency(%q<pyu-ruby-sasl>.freeze, ["< 0.1", ">= 0.0.3.3"])
      s.add_runtime_dependency(%q<rubyntlm>.freeze, ["~> 0.5"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 2.12"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0.9"])
      s.add_development_dependency(%q<rake>.freeze, [">= 10.0"])
      s.add_development_dependency(%q<rack-test>.freeze, [">= 0.6"])
    else
      s.add_dependency(%q<omniauth>.freeze, ["~> 1.3"])
      s.add_dependency(%q<net-ldap>.freeze, ["~> 0.16"])
      s.add_dependency(%q<pyu-ruby-sasl>.freeze, ["< 0.1", ">= 0.0.3.3"])
      s.add_dependency(%q<rubyntlm>.freeze, ["~> 0.5"])
      s.add_dependency(%q<rspec>.freeze, [">= 2.12"])
      s.add_dependency(%q<pry>.freeze, [">= 0.9"])
      s.add_dependency(%q<rake>.freeze, [">= 10.0"])
      s.add_dependency(%q<rack-test>.freeze, [">= 0.6"])
    end
  else
    s.add_dependency(%q<omniauth>.freeze, ["~> 1.3"])
    s.add_dependency(%q<net-ldap>.freeze, ["~> 0.16"])
    s.add_dependency(%q<pyu-ruby-sasl>.freeze, ["< 0.1", ">= 0.0.3.3"])
    s.add_dependency(%q<rubyntlm>.freeze, ["~> 0.5"])
    s.add_dependency(%q<rspec>.freeze, [">= 2.12"])
    s.add_dependency(%q<pry>.freeze, [">= 0.9"])
    s.add_dependency(%q<rake>.freeze, [">= 10.0"])
    s.add_dependency(%q<rack-test>.freeze, [">= 0.6"])
  end
end
