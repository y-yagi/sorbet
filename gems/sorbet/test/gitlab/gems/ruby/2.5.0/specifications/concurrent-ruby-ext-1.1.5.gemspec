# -*- encoding: utf-8 -*-
# stub: concurrent-ruby-ext 1.1.5 ruby lib
# stub: ext/concurrent-ruby-ext/extconf.rb

Gem::Specification.new do |s|
  s.name = "concurrent-ruby-ext".freeze
  s.version = "1.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jerry D'Antonio".freeze, "The Ruby Concurrency Team".freeze]
  s.date = "2019-03-11"
  s.description = "    C extensions to optimize the concurrent-ruby gem when running under MRI.\n    Please see http://concurrent-ruby.com for more information.\n".freeze
  s.email = "concurrent-ruby@googlegroups.com".freeze
  s.extensions = ["ext/concurrent-ruby-ext/extconf.rb".freeze]
  s.extra_rdoc_files = ["README.md".freeze, "LICENSE.md".freeze, "CHANGELOG.md".freeze]
  s.files = ["CHANGELOG.md".freeze, "LICENSE.md".freeze, "README.md".freeze, "ext/concurrent-ruby-ext/extconf.rb".freeze]
  s.homepage = "http://www.concurrent-ruby.com".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3".freeze)
  s.rubygems_version = "2.7.7".freeze
  s.summary = "C extensions to optimize concurrent-ruby under MRI.".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<concurrent-ruby>.freeze, ["= 1.1.5"])
    else
      s.add_dependency(%q<concurrent-ruby>.freeze, ["= 1.1.5"])
    end
  else
    s.add_dependency(%q<concurrent-ruby>.freeze, ["= 1.1.5"])
  end
end
