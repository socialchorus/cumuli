# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'strawboss/version'

Gem::Specification.new do |spec|
  spec.name          = "strawboss"
  spec.version       = Strawboss::VERSION
  spec.authors       = ["SocialChorus", "Kane Baccigalupi", "Fito von Zastrow"]
  spec.email         = ["developers@socialchorus.com"]
  spec.description   = %q{Strawboss runs several foreman processes in different directories}
  spec.summary       = %q{Strawboss makes SOA on Heroku easier by delegating to Foreman in a Procfile}
  spec.homepage      = "http://github.com/socialchorus/strawboss"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "foreman"
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
