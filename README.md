# Google Auth Token Validator

[![Build Status](https://travis-ci.org/hamza/google-auth-token-validator-ruby.svg?branch=master)](https://travis-ci.org/hamza/google-auth-token-validator-ruby)
[![Coverage Status](https://coveralls.io/repos/github/hamza/google-auth-token-validator-ruby/badge.svg?branch=master)](https://coveralls.io/github/hamza/google-auth-token-validator-ruby?branch=master)

The Google Sign-In API gives OAuth2 JSON Web Tokens (JWT) as response data upon user sign-in. A necessary step for a service provider to trust such a token involves validating the token, rather than simply trusting the token, which would allow a malicious client to simply assert itself.

Google provides libraries in several languages (https://goo.gl/jkzS18) to serve this function, as well as an API endpoint that can outsource the task to Google's own servers (thereby introducing an additional network round trip into every authentication step), but a Ruby implementation is missing. This gem fills that gap.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'google-auth-token_validator'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install google-auth-token_validator

## Usage

```ruby
require "googleauth/token_validator"

client_id = "<your client ID>"
id_token = "<user's ID token>"

begin
  valid = Google::Auth::TokenValidator.new(id_token, client_id).validate
rescue Google::Auth::TokenValidator::Error => e
  puts e.message
  valid = false
end

if valid
  # trust this token
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

This gem uses [`dotenv`](https://github.com/bkeepers/dotenv) to set up the test environment. To enable local testing, you'll need to set up the following -

|Key|Description|
|---|---|
|`TEST_CLIENT_ID`|A Google OAuth client ID, used to compare ID tokens against|
|`TEST_CLIENT_SECRET`|A Google OAuth client secret, used to authorize token refreshes|
|`REFRESH_TOKEN`|A refresh token for a test user. It is recommended to use the [Google OAuth Playground](https://developers.google.com/oauthplayground/) to generate one|

**NOTE**: it is not recommended to use your real account for this. Instead use a test user.

Use the [Google Cloud Console](https://console.cloud.google.com) to set up an OAuth id/secret pair for use with testing.

## Contributing

Bug reports and pull requests are welcome on [the repo](https://github.com/hamza/google_signin_token_validator).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
