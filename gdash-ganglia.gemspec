# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.authors       = ["Jonathan Bryant"]
  gem.email         = ["watersofmemory@gmail.com"]
  gem.description   = %q{A GDash plugin for Ganglia}
  gem.summary       = %q{GDash Ganglia Plugin}
  gem.homepage      = ""

  gem.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  gem.files         = `git ls-files`.split("\n")
  gem.test_files    = `git ls-files -- {test,spec}/*`.split("\n")
  gem.name          = "gdash-ganglia"
  gem.require_paths = ["lib"]
  gem.version       = "0.1.0"
  
  gem.add_dependency "gdash"
end
