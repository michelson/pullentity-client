# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'pullentity-client/version'

Gem::Specification.new do |gem|
  gem.name          = "pullentity-client"
  gem.version       = Pullentity::Client::VERSION
  gem.authors       = ["miguel michelson"]
  gem.email         = ["miguelmichelson@gmail.com"]
  gem.description   = %q{Pullentity client for build pullentity.com sites}
  gem.summary       = %q{This gem provides a simple builder workspace for make pullentity sites with haml and sass}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]


  gem.add_runtime_dependency(%q<coffee-script>, ["~> 2.2.0"])

  gem.add_runtime_dependency(%q<colored>, ["~> 1.2"])
  gem.add_runtime_dependency(%q<rake>, ["~> 0.9.2"])
  gem.add_runtime_dependency(%q<nokogiri>, ["~> 1.4.4"])
  gem.add_runtime_dependency(%q<erubis>, ["~> 2.7.0"])
  gem.add_runtime_dependency(%q<rocco>, ["~> 0.7"])
  gem.add_runtime_dependency(%q<thor>, ["~> 0.15.4"])
  gem.add_runtime_dependency(%q<compass>, ["~> 0.12.2"])
  gem.add_runtime_dependency(%q<session>, ["~> 3.1"])
  gem.add_runtime_dependency(%q<middleman>, ["3.0.12"])
  gem.add_runtime_dependency(%q<faraday>)
  gem.add_runtime_dependency("json")

  # gem.add_development_dependency(%q<bundler>, ["~> 1.0.14"])
  gem.add_development_dependency(%q<bundler>, ["~> 1.1"])
  gem.add_development_dependency(%q<rspec>, ["~> 2.6.0"])
  gem.add_development_dependency("debugger")
end
