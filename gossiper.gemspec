$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "gossiper/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "gossiper"
  s.version     = Gossiper::VERSION
  s.authors     = ["Marcelo Jacobus"]
  s.email       = ["marcelo.jacobus@gmail.com"]
  s.homepage    = "https://github.com/mjacobus/gossiper"
  s.summary     = "It eases the creation of messages for the users"
  s.description = "Eases the creation of email messages as well as user notification systems"
  s.license     = "MIT"
  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "shoulda-matchers"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "simplecov"
  s.add_development_dependency "coveralls"
  s.add_development_dependency "faker"
  s.add_development_dependency "interactive_editor"
end
