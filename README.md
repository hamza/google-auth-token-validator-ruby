# Google Auth Token Validator

[![Build Status](https://travis-ci.org/hamza/google-auth-token-validator-ruby.svg?branch=master)](https://travis-ci.org/hamza/google-auth-token-validator-ruby)
[![Coverage Status](https://coveralls.io/repos/github/hamza/google-auth-token-validator-ruby/badge.svg?branch=master)](https://coveralls.io/github/hamza/google-auth-token-validator-ruby?branch=master)

The Google Sign-In API gives OAuth2 JSON Web Tokens (JWT) as response data upon user sign-in.
A necessary step for a service provider to trust such a token involves validating the token,
rather than simply trusting the token, which would allow a malicious client to simply assert
itself.

Google provides libraries for this function in several languages (https://goo.gl/jkzS18) to
serve this function, as well as an API endpoint that can outsource the task to Google's own
servers (thereby introducing an additional network round trip into every authentication step),
but a Ruby implementation is missing. This gem fills that gap.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google-auth_token_validator' # doesn't work yet! stay tuned …
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google-auth_token_validator

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hamza/google_signin_token_validator

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
