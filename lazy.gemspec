# -*- encoding: utf-8 -*-
require File.expand_path('../lib/lazy/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["lefty313"]
  gem.email         = ["lewy313@gmail.com"]
  # gem.description   = %q{TODO: Write a gem description}
  gem.summary       = %q{Manage operating system windows}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "lazy"
  gem.require_paths = ["lib"]
  gem.version       = Lazy::VERSION
end
