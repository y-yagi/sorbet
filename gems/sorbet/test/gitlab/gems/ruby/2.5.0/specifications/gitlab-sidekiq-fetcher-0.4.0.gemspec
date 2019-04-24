# -*- encoding: utf-8 -*-
# stub: gitlab-sidekiq-fetcher 0.4.0 ruby lib

Gem::Specification.new do |s|
  s.name = "gitlab-sidekiq-fetcher".freeze
  s.version = "0.4.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["TEA".freeze, "GitLab".freeze]
  s.date = "2018-12-19"
  s.description = "Redis reliable queue pattern implemented in Sidekiq".freeze
  s.email = "valery@gitlab.com".freeze
  s.homepage = "https://gitlab.com/gitlab-org/sidekiq-reliable-fetch/".freeze
  s.licenses = ["LGPL-3.0".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Reliable fetch extension for Sidekiq".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sidekiq>.freeze, ["~> 5"])
    else
      s.add_dependency(%q<sidekiq>.freeze, ["~> 5"])
    end
  else
    s.add_dependency(%q<sidekiq>.freeze, ["~> 5"])
  end
end
