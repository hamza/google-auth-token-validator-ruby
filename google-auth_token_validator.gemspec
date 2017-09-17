# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "googleauth/token_validator/version"

Gem::Specification.new do |spec|
  spec.name          = "google-auth-token_validator"
  spec.version       = Google::Auth::TokenValidator::VERSION
  spec.date          = Time.now.strftime('%Y-%m-%d')
  spec.authors       = ["Hamza Tayeb"]
  spec.email         = ["hamza.tayeb@gmail.com"]

  spec.summary       = "Ruby gem to validate signed JSON Web Tokens from Google's sign-in API"
  spec.description   = <<-DESC
    The Google Sign-In API gives OAuth2 JSON Web Tokens (JWT) as response data upon user sign-in.
    A necessary step for a service provider to trust such a token is validatation. Accepting the
    token without validation would allow a malicious client to simply assert itself in your system.
    \n\n

    Google provides libraries in several languages (https://goo.gl/jkzS18) to accomplish this,
    as well as an API endpoint that can outsource the task to Google's own servers (thereby
    introducing an additional network round trip into every authentication step), but a Ruby
    implementation is missing. This gem fills that gap.
  DESC

  spec.homepage      = "https://github.com/hamza/google-signin-token-validator"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.15"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "coveralls", "~> 0.8"
  spec.add_development_dependency "pry", "~> 0.10"
  spec.add_development_dependency "dotenv", "~> 2.2"
end
