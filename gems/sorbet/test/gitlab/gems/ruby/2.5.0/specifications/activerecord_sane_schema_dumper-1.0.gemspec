# -*- encoding: utf-8 -*-
# stub: activerecord_sane_schema_dumper 1.0 ruby lib

Gem::Specification.new do |s|
  s.name = "activerecord_sane_schema_dumper".freeze
  s.version = "1.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["R\u00E9mi Pr\u00E9vost".freeze]
  s.date = "2016-09-05"
  s.description = "ActiveRecord::SaneSchemaDumper removes useless/harmful whitespace from Rails\u2019 generated `db/schema.rb` files.".freeze
  s.email = ["rprevost@mirego.com".freeze]
  s.homepage = "https://github.com/mirego/activerecord_sane_schema_dumper".freeze
  s.licenses = ["BSD 3-Clause".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.2.2".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "ActiveRecord::SaneSchemaDumper removes useless/harmful whitespace from Rails\u2019 generated `db/schema.rb` files.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_development_dependency(%q<rubocop>.freeze, ["= 0.27.1"])
      s.add_development_dependency(%q<phare>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 3.1"])
      s.add_development_dependency(%q<pg>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rails>.freeze, ["< 6", ">= 5"])
    else
      s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
      s.add_dependency(%q<rubocop>.freeze, ["= 0.27.1"])
      s.add_dependency(%q<phare>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
      s.add_dependency(%q<pg>.freeze, [">= 0"])
      s.add_dependency(%q<rails>.freeze, ["< 6", ">= 5"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, ["~> 1.7"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    s.add_dependency(%q<rubocop>.freeze, ["= 0.27.1"])
    s.add_dependency(%q<phare>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 3.1"])
    s.add_dependency(%q<pg>.freeze, [">= 0"])
    s.add_dependency(%q<rails>.freeze, ["< 6", ">= 5"])
  end
end
