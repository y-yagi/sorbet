# -*- encoding: utf-8 -*-
# stub: email_reply_trimmer 0.1.12 ruby lib

Gem::Specification.new do |s|
  s.name = "email_reply_trimmer".freeze
  s.version = "0.1.12"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["R\u00E9gis Hanol".freeze]
  s.date = "2018-05-17"
  s.description = "EmailReplyTrimmer is a small library to trim replies from plain text email.".freeze
  s.email = ["regis+rubygems@hanol.fr".freeze]
  s.homepage = "https://github.com/discourse/email_reply_trimmer".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Library to trim replies from plain text email.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.52.1"])
    else
      s.add_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.52.1"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["~> 12"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.52.1"])
  end
end
