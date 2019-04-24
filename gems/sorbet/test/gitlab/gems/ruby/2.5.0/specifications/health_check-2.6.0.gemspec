# -*- encoding: utf-8 -*-
# stub: health_check 2.6.0 ruby lib

Gem::Specification.new do |s|
  s.name = "health_check".freeze
  s.version = "2.6.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ian Heggie".freeze]
  s.date = "2016-12-07"
  s.description = "  \tSimple health check of Rails app for uptime monitoring with Pingdom, NewRelic, EngineYard or uptime.openacs.org etc.\n".freeze
  s.email = ["ian@heggie.biz".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze]
  s.homepage = "https://github.com/ianheggie/health_check".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Simple health check of Rails app for uptime monitoring with Pingdom, NewRelic, EngineYard or uptime.openacs.org etc.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rails>.freeze, [">= 4.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0.8.3"])
      s.add_development_dependency(%q<shoulda>.freeze, ["~> 2.11.0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.2"])
    else
      s.add_dependency(%q<rails>.freeze, [">= 4.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0.8.3"])
      s.add_dependency(%q<shoulda>.freeze, ["~> 2.11.0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.2"])
    end
  else
    s.add_dependency(%q<rails>.freeze, [">= 4.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0.8.3"])
    s.add_dependency(%q<shoulda>.freeze, ["~> 2.11.0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.2"])
  end
end
