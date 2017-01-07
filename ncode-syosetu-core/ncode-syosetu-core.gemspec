# coding: utf-8
require_relative 'lib/ncode_syosetu/version'

Gem::Specification.new do |spec|
  spec.name          = "ncode-syosetu-core"
  spec.version       = NcodeSyosetu::VERSION
  spec.authors       = ["hogelog"]
  spec.email         = ["konbu.komuro@gmail.com"]

  spec.summary       = %q{Ncode syosetu scraper}
  spec.homepage      = "https://github.com/hogelog/ncode-syosetu"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "mechanize", "2.7.2"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
