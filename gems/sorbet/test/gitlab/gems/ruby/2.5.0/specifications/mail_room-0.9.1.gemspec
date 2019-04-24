# -*- encoding: utf-8 -*-
# stub: mail_room 0.9.1 ruby lib

Gem::Specification.new do |s|
  s.name = "mail_room".freeze
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tony Pitale".freeze]
  s.date = "2017-02-04"
  s.description = "mail_room will proxy email (gmail) from IMAP to a delivery method".freeze
  s.email = ["tpitale@gmail.com".freeze]
  s.executables = ["mail_room".freeze]
  s.files = ["bin/mail_room".freeze]
  s.homepage = "http://github.com/tpitale/mail_room".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "mail_room will proxy email (gmail) from IMAP to a callback URL, logger, or letter_opener".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_development_dependency(%q<bourne>.freeze, [">= 0"])
      s.add_development_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_development_dependency(%q<fakeredis>.freeze, [">= 0"])
      s.add_development_dependency(%q<faraday>.freeze, [">= 0"])
      s.add_development_dependency(%q<mail>.freeze, [">= 0"])
      s.add_development_dependency(%q<letter_opener>.freeze, [">= 0"])
      s.add_development_dependency(%q<redis-namespace>.freeze, [">= 0"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_development_dependency(%q<charlock_holmes>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_dependency(%q<bourne>.freeze, [">= 0"])
      s.add_dependency(%q<simplecov>.freeze, [">= 0"])
      s.add_dependency(%q<fakeredis>.freeze, [">= 0"])
      s.add_dependency(%q<faraday>.freeze, [">= 0"])
      s.add_dependency(%q<mail>.freeze, [">= 0"])
      s.add_dependency(%q<letter_opener>.freeze, [">= 0"])
      s.add_dependency(%q<redis-namespace>.freeze, [">= 0"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<charlock_holmes>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<bourne>.freeze, [">= 0"])
    s.add_dependency(%q<simplecov>.freeze, [">= 0"])
    s.add_dependency(%q<fakeredis>.freeze, [">= 0"])
    s.add_dependency(%q<faraday>.freeze, [">= 0"])
    s.add_dependency(%q<mail>.freeze, [">= 0"])
    s.add_dependency(%q<letter_opener>.freeze, [">= 0"])
    s.add_dependency(%q<redis-namespace>.freeze, [">= 0"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<charlock_holmes>.freeze, [">= 0"])
  end
end
