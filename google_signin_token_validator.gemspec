Gem::Specification.new do |s|
  s.name        = "google_signin_token_validator"
  s.version     = "0.0.0"
  s.date        = "2017-09-05"
  s.summary     = "Ruby gem to validate signed JSON Web Tokens from Google's sign-in API"
  s.description = <<-DESC
    The Google Sign-In API gives OAuth2 JSON Web Tokens (JWT) as response data upon user sign-in.
    A necessary step for a service provider to trust such a token involves validating the token,
    rather than simply trusting the token, which would allow a malicious client to simply assert
    itself.

    Google provides libraries for this function in several langauges (https://goo.gl/jkzS18) to
    serve this function, as well as an API endpoint that can outsource the task to Google's own
    servers (thereby introducing an additional network round trip into every authentication step),
    but a Ruby implementation is missing. This gem fills that gap.
  DESC
  s.authors     = ["Hamza Tayeb"]
  s.email       = "hamza.tayeb@gmail.com"
  s.files       = ["lib/google_signin_token_validator.rb"]
  s.homepage    = "https://github.com/hamza/google-signin-token-validator"
  s.license       = "MIT"
end
