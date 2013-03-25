# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'zeus/parallel_tests/version'

Gem::Specification.new do |spec|
  spec.name          = "zeus-parallel_tests"
  spec.version       = Zeus::ParallelTests::VERSION
  spec.authors       = ["Artur Roszczyk"]
  spec.email         = ["artur.roszczyk@gmail.com"]
  spec.description   = %q{Integration for zeus and parallel_tests}
  spec.summary       = %q{}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "zeus", "~> 0.13.3"
  spec.add_dependency "parallel_tests", "~> 0.10.4"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
