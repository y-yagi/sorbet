# -*- encoding: utf-8 -*-
# stub: prometheus-client-mmap 0.9.5 ruby lib
# stub: ext/fast_mmaped_file/extconf.rb

Gem::Specification.new do |s|
  s.name = "prometheus-client-mmap".freeze
  s.version = "0.9.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tobias Schmidt".freeze, "Pawe\u0142 Chojnacki".freeze]
  s.date = "2018-11-09"
  s.email = ["ts@soundcloud.com".freeze, "pawel@gitlab.com".freeze]
  s.extensions = ["ext/fast_mmaped_file/extconf.rb".freeze]
  s.files = ["ext/fast_mmaped_file/extconf.rb".freeze]
  s.homepage = "https://gitlab.com/gitlab-org/prometheus-client-mmap".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "A suite of instrumentation metric primitivesthat can be exposed through a web services interface.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<fuzzbert>.freeze, [">= 1.0.4", "~> 1.0"])
      s.add_development_dependency(%q<gem_publisher>.freeze, ["~> 1.1.1"])
      s.add_development_dependency(%q<rake-compiler>.freeze, ["~> 1.0.4"])
      s.add_development_dependency(%q<ruby-prof>.freeze, ["~> 0.16.2"])
    else
      s.add_dependency(%q<fuzzbert>.freeze, [">= 1.0.4", "~> 1.0"])
      s.add_dependency(%q<gem_publisher>.freeze, ["~> 1.1.1"])
      s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0.4"])
      s.add_dependency(%q<ruby-prof>.freeze, ["~> 0.16.2"])
    end
  else
    s.add_dependency(%q<fuzzbert>.freeze, [">= 1.0.4", "~> 1.0"])
    s.add_dependency(%q<gem_publisher>.freeze, ["~> 1.1.1"])
    s.add_dependency(%q<rake-compiler>.freeze, ["~> 1.0.4"])
    s.add_dependency(%q<ruby-prof>.freeze, ["~> 0.16.2"])
  end
end
