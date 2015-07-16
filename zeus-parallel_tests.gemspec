# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zeus/parallel_tests/version'

Gem::Specification.new do |spec|
  spec.name          = 'zeus-parallel_tests'
  spec.version       = Zeus::ParallelTests::VERSION
  spec.authors       = ['Artur Roszczyk']
  spec.email         = ['artur.roszczyk@gmail.com']
  spec.description   = 'Integration for zeus and parallel_tests'
  spec.summary       = ''
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($INPUT_RECORD_SEPARATOR)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'zeus', '>= 0.13.0'
  spec.add_dependency 'parallel_tests', '>= 0.11.3'

  spec.add_development_dependency 'appraisal'
  spec.add_development_dependency 'bundler'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rspec', '>= 3.0'

  # Gems used by dummy app in testing.
  spec.add_development_dependency 'cucumber-rails'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'sqlite3'
end
