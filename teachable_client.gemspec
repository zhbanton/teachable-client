# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "teachable_client/version"

Gem::Specification.new do |spec|
  spec.name          = "teachable_client"
  spec.version       = TeachableClient::VERSION
  spec.authors       = ["zhbanton"]
  spec.email         = ["zhbanton@gmail.com"]

  spec.summary       = %q{Wraps Teachable Mock API}
  spec.description   = %q{Wraps Teachable Mock API}
  spec.homepage      = "https://github.com/zhbanton/teachable-client"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency "vcr"
  spec.add_development_dependency "webmock"

  spec.add_dependency "faraday"
  spec.add_dependency "json"
end
