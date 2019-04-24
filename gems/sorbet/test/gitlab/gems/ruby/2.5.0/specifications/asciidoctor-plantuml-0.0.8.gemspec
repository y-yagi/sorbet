# -*- encoding: utf-8 -*-
# stub: asciidoctor-plantuml 0.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "asciidoctor-plantuml".freeze
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Horacio Sanson".freeze]
  s.date = "2017-02-08"
  s.description = "Asciidoctor PlantUML extension".freeze
  s.email = ["hsanson@gmail.com".freeze]
  s.homepage = "https://github.com/hsanson/asciidoctor-plantuml".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "An extension for Asciidoctor that enables support for PlantUML diagrams.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.5"])
      s.add_development_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_runtime_dependency(%q<asciidoctor>.freeze, ["~> 1.5"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.5"])
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
      s.add_dependency(%q<asciidoctor>.freeze, ["~> 1.5"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.3"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.5"])
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.6"])
    s.add_dependency(%q<asciidoctor>.freeze, ["~> 1.5"])
  end
end
