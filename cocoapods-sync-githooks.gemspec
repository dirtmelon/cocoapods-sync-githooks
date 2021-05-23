# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cocoapods-sync-githooks/gem_version.rb'

Gem::Specification.new do |spec|
  spec.name          = 'cocoapods-sync-githooks'
  spec.version       = CocoapodsSyncGithooks::VERSION
  spec.authors       = ['dirtmelon']
  spec.email         = ['0xffdirtmelon@gmail.com']
  spec.description   = %q{A short description of cocoapods-sync-githooks.}
  spec.summary       = %q{A longer description of cocoapods-sync-githooks.}
  spec.homepage      = 'https://github.com/EXAMPLE/cocoapods-sync-githooks'
  spec.license       = 'MIT'

  spec.files         = Dir['lib/**/*']
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
