# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'active_params/version'

Gem::Specification.new do |spec|
  spec.name          = "active_params"
  spec.version       = ActiveParams::VERSION
  spec.authors       = ["choonkeat"]
  spec.email         = ["choonkeat@gmail.com"]

  spec.summary       = %q{Automatic strong parameters}
  spec.description   = %q{Bye bye strong parameters falls}
  spec.homepage      = "http://github.com/choonkeat/active_params"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
end
