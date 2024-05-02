Gem::Specification.new do |spec|
  spec.name = "rack-server-timing"
  spec.version = "0.1.0"
  spec.authors = ["Adam Daniels"]

  spec.summary = %q(Server-Timing headers for Rack applications)
  spec.homepage = "https://github.com/adam12/rack-server-timing"
  spec.license = "MIT"

  spec.files = ["README.md", "Rakefile"] + Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]

  spec.add_dependency "rack", ">= 2.0", "< 4.0"
end
