# encoding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'forematter/version'

Gem::Specification.new do |spec|
  spec.name        = 'forematter'
  spec.version     = Forematter::VERSION.gsub('-', '.')
  spec.authors     = ['Justin Hileman']
  spec.email       = 'justin@justinhileman.info'
  spec.homepage    = 'https://github.com/bobthecow/forematter'
  spec.summary     = 'the frontmatter-aware friend for your static site'
  spec.description = 'Forematter is the frontmatter-aware friend for your static site'
  spec.license     = 'MIT'

  spec.files  = %w(CHANGELOG.md CONTRIBUTING.md LICENSE.md README.md Rakefile forematter.gemspec)
  spec.files += Dir['lib/**/*.rb']
  spec.files += Dir['spec/**/*.rb']

  spec.executables  = %w(fore)

  spec.add_dependency 'cri', '~> 2.4'
  spec.add_dependency 'stringex'
  spec.add_dependency 'titleize'

  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'rake'
end
