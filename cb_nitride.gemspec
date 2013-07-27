# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cb_nitride/version'

Gem::Specification.new do |spec|
  spec.name          = "cb_nitride"
  spec.version       = CbNitride::VERSION
  spec.authors       = ["Alex Jarvis"]
  spec.email         = ["alxjrvs@gmail.com"]
  spec.description   = %q{A Gem for accessing information from the diamond comics backend.}
  spec.summary       = %q{Only useable with a qualified Diamond Comic Retailer!}
  spec.homepage      = "http://github.com/alxjrvs"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_runtime_dependency "mechanize", "~> 2.7"
  spec.add_runtime_dependency "nokogiri", "~> 1.5"
end
