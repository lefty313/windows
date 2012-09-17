# -*- encoding: utf-8 -*-
require File.expand_path('../lib/windows/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["lefty313"]
  gem.email         = ["lewy313@gmail.com"]
  # gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{Manage operating system windows}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "windows"
  gem.require_paths = ["lib"]
  gem.version       = Windows::VERSION

  gem.add_development_dependency "rspec"
  gem.add_development_dependency "pry"
  # gem.add_development_dependency "libnotify"
  gem.add_development_dependency "guard-rspec"
  gem.add_development_dependency "simplecov"
  gem.add_development_dependency "fuubar"
  gem.add_development_dependency 'rb-inotify', '~> 0.8.8'
end
