# -*- encoding: utf-8 -*-
# stub: batch-loader 1.2.2 ruby lib

Gem::Specification.new do |s|
  s.name = "batch-loader".freeze
  s.version = "1.2.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["exAspArk".freeze]
  s.bindir = "exe".freeze
  s.date = "2018-12-03"
  s.description = "Powerful tool to avoid N+1 DB or HTTP queries".freeze
  s.email = ["exaspark@gmail.com".freeze]
  s.homepage = "https://github.com/exAspArk/batch-loader".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.1.0".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Powerful tool to avoid N+1 DB or HTTP queries".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.15"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_development_dependency(%q<graphql>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<pry-byebug>.freeze, ["~> 3.4"])
      s.add_development_dependency(%q<benchmark-ips>.freeze, ["~> 2.7"])
      s.add_development_dependency(%q<ruby-prof>.freeze, ["~> 0.16"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.15"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
      s.add_dependency(%q<graphql>.freeze, ["~> 1.6"])
      s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.4"])
      s.add_dependency(%q<benchmark-ips>.freeze, ["~> 2.7"])
      s.add_dependency(%q<ruby-prof>.freeze, ["~> 0.16"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.15"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    s.add_dependency(%q<graphql>.freeze, ["~> 1.6"])
    s.add_dependency(%q<pry-byebug>.freeze, ["~> 3.4"])
    s.add_dependency(%q<benchmark-ips>.freeze, ["~> 2.7"])
    s.add_dependency(%q<ruby-prof>.freeze, ["~> 0.16"])
  end
end
