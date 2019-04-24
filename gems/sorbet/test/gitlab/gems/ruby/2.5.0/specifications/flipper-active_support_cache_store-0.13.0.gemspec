# -*- encoding: utf-8 -*-
# stub: flipper-active_support_cache_store 0.13.0 ruby lib

Gem::Specification.new do |s|
  s.name = "flipper-active_support_cache_store".freeze
  s.version = "0.13.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["John Nunemaker".freeze]
  s.date = "2018-03-04"
  s.description = "ActiveSupport::Cache store adapter for Flipper".freeze
  s.email = ["nunemaker@gmail.com".freeze]
  s.homepage = "https://github.com/jnunemaker/flipper".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "ActiveSupport::Cache store adapter for Flipper".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<flipper>.freeze, ["~> 0.13.0"])
      s.add_runtime_dependency(%q<activesupport>.freeze, ["< 6", ">= 3.2"])
    else
      s.add_dependency(%q<flipper>.freeze, ["~> 0.13.0"])
      s.add_dependency(%q<activesupport>.freeze, ["< 6", ">= 3.2"])
    end
  else
    s.add_dependency(%q<flipper>.freeze, ["~> 0.13.0"])
    s.add_dependency(%q<activesupport>.freeze, ["< 6", ">= 3.2"])
  end
end
