# -*- encoding: utf-8 -*-
# stub: sham_rack 1.3.6 ruby lib

Gem::Specification.new do |s|
  s.name = "sham_rack".freeze
  s.version = "1.3.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mike Williams".freeze]
  s.date = "2013-04-05"
  s.description = "ShamRack plumbs Net::HTTP directly into Rack, for quick and easy HTTP testing.".freeze
  s.email = "mdub@dogbiscuit.org".freeze
  s.homepage = "http://github.com/mdub/sham_rack".freeze
  s.rubyforge_project = "shamrack".freeze
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Net::HTTP-to-Rack plumbing".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rack>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rack>.freeze, [">= 0"])
  end
end
