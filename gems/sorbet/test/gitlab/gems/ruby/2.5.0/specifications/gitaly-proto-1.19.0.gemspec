# -*- encoding: utf-8 -*-
# stub: gitaly-proto 1.19.0 ruby ruby/lib

Gem::Specification.new do |s|
  s.name = "gitaly-proto".freeze
  s.version = "1.19.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["ruby/lib".freeze]
  s.authors = ["Jacob Vosmaer".freeze]
  s.date = "2019-03-27"
  s.description = "Auto-generated gRPC client for gitaly.".freeze
  s.email = ["jacob@gitlab.com".freeze]
  s.homepage = "https://gitlab.com/gitlab-org/gitaly-proto".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.7.7".freeze
  s.summary = "Auto-generated gRPC client for gitaly".freeze

  s.installed_by_version = "2.7.7" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<grpc>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<grpc>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<grpc>.freeze, ["~> 1.0"])
  end
end
