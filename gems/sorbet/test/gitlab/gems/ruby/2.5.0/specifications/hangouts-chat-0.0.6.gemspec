# -*- encoding: utf-8 -*-
# stub: hangouts-chat 0.0.6 ruby lib

Gem::Specification.new do |s|
  s.name = "hangouts-chat".freeze
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["enzinia".freeze]
  s.date = "2019-01-02"
  s.description = "Send messages to G Suite Hangouts Chat rooms using incoming webhooks and Net::HTTP::Post".freeze
  s.email = "vkukovskij@gmail.com".freeze
  s.homepage = "https://github.com/enzinia/hangouts-chat".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Library for sending messages to Hangouts Chat rooms".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 5"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_development_dependency(%q<rubocop>.freeze, ["<= 0.54.0"])
      s.add_development_dependency(%q<webmock>.freeze, ["~> 3"])
      s.add_development_dependency(%q<yard>.freeze, ["> 0.9.11", "~> 0.9"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1"])
      s.add_dependency(%q<minitest>.freeze, ["~> 5"])
      s.add_dependency(%q<rake>.freeze, ["~> 12"])
      s.add_dependency(%q<rubocop>.freeze, ["<= 0.54.0"])
      s.add_dependency(%q<webmock>.freeze, ["~> 3"])
      s.add_dependency(%q<yard>.freeze, ["> 0.9.11", "~> 0.9"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1"])
    s.add_dependency(%q<minitest>.freeze, ["~> 5"])
    s.add_dependency(%q<rake>.freeze, ["~> 12"])
    s.add_dependency(%q<rubocop>.freeze, ["<= 0.54.0"])
    s.add_dependency(%q<webmock>.freeze, ["~> 3"])
    s.add_dependency(%q<yard>.freeze, ["> 0.9.11", "~> 0.9"])
  end
end
