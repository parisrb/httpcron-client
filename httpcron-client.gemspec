# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "httpcron-client/version"

Gem::Specification.new do |s|
  s.name        = "httpcron-client"
  s.version     = Httpcron::Client::VERSION
  s.authors     = ["Paris.rb team"]
  s.homepage    = "https://github.com/parisrb/httpcron-client"
  s.summary     = "A ruby client for httpcron"
  s.description = "A ruby client for httpcron"

  s.rubyforge_project = "httpcron-client"

  s.add_runtime_dependency 'rest-client', '~> 1.6.7'
  s.add_runtime_dependency 'net-http-digest_auth', '~> 1.1.1'
  s.add_runtime_dependency 'rest-client', '~> 1.6.7'

  s.add_development_dependency 'webmock', '~> 1.7.4'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
