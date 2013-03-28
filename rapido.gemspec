# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rapido/version'

Gem::Specification.new do |spec|
  spec.name          = "rapido"
  spec.version       = Rapido::VERSION
  spec.authors       = ["Justin Ricaurte"]
  spec.email         = ["justin@justinricaurte.com"]
  spec.description   = %q{Make descriptive rspec tests fast!}
  spec.summary       = %q{As descriptive as lots of "it"'s but without the overhead.}
  spec.homepage      = "https://github.com/ricaurte/rapido"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_dependency "rspec-core"
end
