# -*- encoding: utf-8 -*-
$LOAD_PATH.push(File.expand_path "../lib", __FILE__)
require "cloudxls/version"

Gem::Specification.new do |gem|
  gem.name          = "cloudxls"
  gem.authors       = ["Sebastian Burkhard"]
  gem.email         = ["sebi.burkhard@gmail.com"]
  gem.description   = %q{Provides a simple ruby wrapper around the CloudXLS API}
  gem.summary       = %q{Provides a simple ruby wrapper around the CloudXLS API}
  gem.homepage      = "https://cloudxls.com"
  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  gem.require_paths = ["lib"]
  gem.version       = CloudXLS::VERSION

  gem.add_dependency('rest-client', '~> 1.4')
  gem.add_dependency('multi_json', '>= 1.0.4', '< 2')

  gem.add_development_dependency "minitest"
  gem.add_development_dependency "rake"
  gem.add_development_dependency "webmock"
end
