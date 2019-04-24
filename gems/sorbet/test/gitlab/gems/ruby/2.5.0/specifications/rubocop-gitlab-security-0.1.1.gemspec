# -*- encoding: utf-8 -*-
# stub: rubocop-gitlab-security 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rubocop-gitlab-security".freeze
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brian Neel".freeze]
  s.date = "2017-12-14"
  s.description = "Basic security checking for Ruby files.\nA plugin for the RuboCop code style enforcing & linting tool.\n".freeze
  s.email = ["brian@gitlab.com".freeze]
  s.extra_rdoc_files = ["MIT-LICENSE.md".freeze, "README.md".freeze]
  s.files = ["MIT-LICENSE.md".freeze, "README.md".freeze]
  s.homepage = "https://gitlab.com/gitlab-org/rubocop-gitlab-security/".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Basic security checks for projects".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rubocop>.freeze, [">= 0.51"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rubocop>.freeze, [">= 0.51"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rubocop>.freeze, [">= 0.51"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
  end
end
