$:.push File.expand_path("lib", __dir__)

require "openopus/core/people/version"

Gem::Specification.new do |spec|
  spec.name        = "openopus-core-people"
  spec.version     = Openopus::Core::People::VERSION
  spec.authors     = ["Brian J. Fox"]
  spec.email       = ["bfox@opuslogica.com"]
  spec.homepage    = "https://github.com/openopus/openopus-core-people"
  spec.summary     = "Model the real world of people in your application, making user interaction robust."
  spec.description = "A person can have many email addresses, but this is not usually represented in applications.  openopus/core/people creates the database structure, relations, and convenience functions for your application so you don't have to.  Just connect your end user model, and away you go."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_runtime_dependency 'rails', '~> 5.2', '> 5.2.3'
  spec.add_runtime_dependency 'phony_rails', '~> 0.14', '> 0.14'
  spec.add_runtime_dependency "bcrypt", "~> 3.1.13"
end
