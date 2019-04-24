# -*- encoding: utf-8 -*-
# stub: u2f 0.2.1 ruby lib

Gem::Specification.new do |s|
  s.name = "u2f".freeze
  s.version = "0.2.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Johan Brissmyr".freeze, "Sebastian Wallin".freeze]
  s.date = "2015-10-06"
  s.description = "Library for handling registration and authentication of U2F devices".freeze
  s.email = ["brissmyr@gmail.com".freeze, "sebastian.wallin@gmail.com".freeze]
  s.homepage = "https://github.com/castle/ruby-u2f".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "U2F library".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.3.2"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
      s.add_development_dependency(%q<json_expressions>.freeze, ["~> 0.8.3"])
      s.add_development_dependency(%q<rubocop>.freeze, ["~> 0.27.1"])
      s.add_development_dependency(%q<coveralls>.freeze, ["~> 0.7.2"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.9.1"])
    else
      s.add_dependency(%q<rake>.freeze, ["~> 10.3.2"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
      s.add_dependency(%q<json_expressions>.freeze, ["~> 0.8.3"])
      s.add_dependency(%q<rubocop>.freeze, ["~> 0.27.1"])
      s.add_dependency(%q<coveralls>.freeze, ["~> 0.7.2"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.9.1"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["~> 10.3.2"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1.0"])
    s.add_dependency(%q<json_expressions>.freeze, ["~> 0.8.3"])
    s.add_dependency(%q<rubocop>.freeze, ["~> 0.27.1"])
    s.add_dependency(%q<coveralls>.freeze, ["~> 0.7.2"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.9.1"])
  end
end
