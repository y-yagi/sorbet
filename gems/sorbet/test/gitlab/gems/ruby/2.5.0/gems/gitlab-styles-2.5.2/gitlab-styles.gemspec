lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gitlab/styles/version'

Gem::Specification.new do |spec|
  spec.name          = 'gitlab-styles'
  spec.version       = Gitlab::Styles::VERSION
  spec.authors       = ['GitLab']
  spec.email         = ['remy@rymai.me']

  spec.summary       = 'GitLab style guides and shared style configs.'
  spec.homepage      = 'https://gitlab.com/gitlab-org/gitlab-styles'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'rubocop', '~> 0.54.0'
  spec.add_dependency 'rubocop-gitlab-security', '~> 0.1.0'
  spec.add_dependency 'rubocop-rspec', '~> 1.19'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
end
