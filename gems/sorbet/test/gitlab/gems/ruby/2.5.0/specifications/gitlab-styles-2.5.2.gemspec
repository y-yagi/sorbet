# -*- encoding: utf-8 -*-
# stub: gitlab-styles 2.5.2 ruby lib

Gem::Specification.new do |s|
  s.name = "gitlab-styles".freeze
  s.version = "2.5.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["GitLab".freeze]
  s.bindir = "exe".freeze
  s.date = "2019-04-10"
  s.email = ["remy@rymai.me".freeze]
  s.homepage = "https://gitlab.com/gitlab-org/gitlab-styles".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "GitLab style guides and shared style configs.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubocop>.freeze, ["~> 0.54.0"])
      s.add_runtime_dependency(%q<rubocop-gitlab-security>.freeze, ["~> 0.1.0"])
      s.add_runtime_dependency(%q<rubocop-rspec>.freeze, ["~> 1.19"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.54.0"])
      s.add_dependency(%q<rubocop-gitlab-security>.freeze, ["~> 0.1.0"])
      s.add_dependency(%q<rubocop-rspec>.freeze, ["~> 1.19"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.54.0"])
    s.add_dependency(%q<rubocop-gitlab-security>.freeze, ["~> 0.1.0"])
    s.add_dependency(%q<rubocop-rspec>.freeze, ["~> 1.19"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.16"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.0"])
  end
end
