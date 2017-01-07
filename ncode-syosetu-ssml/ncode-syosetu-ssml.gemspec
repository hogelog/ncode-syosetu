# coding: utf-8
GEM_VERSION = File.read("../ncode-syosetu-core/lib/ncode_syosetu/version.rb") =~ /"(.+)"/ && $1

Gem::Specification.new do |spec|
  spec.name          = "ncode-syosetu-ssml"
  spec.version       = GEM_VERSION
  spec.authors       = ["hogelog"]
  spec.email         = ["konbu.komuro@gmail.com"]

  spec.summary       = %q{Ncode syosetu to ssml converter}
  spec.homepage      = "https://github.com/hogelog/ncode-syosetu"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "ncode-syosetu-core", GEM_VERSION
  spec.add_dependency "sanitize", "~> 4.4"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
end
