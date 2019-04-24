# -*- encoding: utf-8 -*-
# stub: gitlab-markup 1.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "gitlab-markup".freeze
  s.version = "1.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://gitlab.com/gitlab-org/gitlab-markup/issues", "changelog_uri" => "https://gitlab.com/gitlab-org/gitlab-markup/blob/master/HISTORY.md", "source_code_uri" => "https://gitlab.com/gitlab-org/gitlab-markup" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Chris Wanstrath".freeze]
  s.date = "2019-03-05"
  s.description = "This gem is used by GitLab to render any non Markdown markup".freeze
  s.email = "chris@ozmm.org".freeze
  s.executables = ["gitlab-markup".freeze]
  s.files = ["bin/gitlab-markup".freeze]
  s.homepage = "https://gitlab.com/gitlab-org/gitlab-markup".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Fork from github-markup GitLab uses to render non markdown content".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<activesupport>.freeze, ["~> 4.0"])
      s.add_development_dependency(%q<html-pipeline>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5.4.3"])
      s.add_development_dependency(%q<nokogiri>.freeze, ["~> 1.6.1"])
      s.add_development_dependency(%q<nokogiri-diff>.freeze, ["~> 0.2.0"])
      s.add_development_dependency(%q<sanitize>.freeze, ["~> 2.1.0"])
    else
      s.add_dependency(%q<activesupport>.freeze, ["~> 4.0"])
      s.add_dependency(%q<html-pipeline>.freeze, ["~> 1.0"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5.4.3"])
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6.1"])
      s.add_dependency(%q<nokogiri-diff>.freeze, ["~> 0.2.0"])
      s.add_dependency(%q<sanitize>.freeze, ["~> 2.1.0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, ["~> 4.0"])
    s.add_dependency(%q<html-pipeline>.freeze, ["~> 1.0"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5.4.3"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6.1"])
    s.add_dependency(%q<nokogiri-diff>.freeze, ["~> 0.2.0"])
    s.add_dependency(%q<sanitize>.freeze, ["~> 2.1.0"])
  end
end
