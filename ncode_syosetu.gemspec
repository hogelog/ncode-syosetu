# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ncode_syosetu/version'

Gem::Specification.new do |spec|
  spec.name          = "ncode-syosetu"
  spec.version       = NcodeSyosetu::VERSION
  spec.authors       = ["hogelog"]
  spec.email         = ["konbu.komuro@gmail.com"]
  spec.description   = %q{Ncode syosetu scraper}
  spec.summary       = %q{Ncode syosetu scraper}
  spec.homepage      = "https://github.com/hogelog/ncode-syosetu"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize", "~> 2.7.3"
  spec.add_dependency "gepub", "~> 0.6.4.6"

  spec.add_development_dependency "bundler", "~> 1.5.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "spring"
  spec.add_development_dependency "webmock"
end
