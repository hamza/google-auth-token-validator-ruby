require "spec_helper"
require "net/http"
require "uri"
require "pry"

TOKEN_REFRESH_URL = URI("https://www.googleapis.com/oauth2/v4/token")

RSpec.describe Google::Auth::TokenValidator do
  include_context "test tokens"

  before :all do
    @client_id = ENV["TEST_CLIENT_ID"]

    response = Net::HTTP.post_form(
      TOKEN_REFRESH_URL,
      {
        client_id: @client_id,
        client_secret: ENV["TEST_CLIENT_SECRET"],
        refresh_token: ENV["REFRESH_TOKEN"],
        grant_type: "refresh_token"
      }
    )

    @refreshed_id_token = JSON.parse(response.body, symbolize_names: true)[:id_token]
  end

  before :each do
    @validator = Google::Auth::TokenValidator.new @refreshed_id_token, @client_id
  end

  it "has a version number" do
    expect(Google::Auth::TokenValidator::VERSION).not_to be nil
  end

  it "validates a token" do
    expect(@validator.validate).to be(true)
  end

  it "validates a token when passed multiple client IDs" do
    client_ids = [@client_id, "additional-client-ID"]
    validator = Google::Auth::TokenValidator.new @refreshed_id_token, client_ids

    expect(validator.validate).to be(true)
  end

  it "fails when initialized w/out a token consisting of 3 period-delimited segments" do
    expect {
      Google::Auth::TokenValidator.new "not.token", @client_id
    }.to raise_error(Google::Auth::TokenValidator::Error, /Wrong number of segments in token/)
  end

  %i(@signed @signature @envelope @payload).each do |param|
    it "fails when #{param} param is missing" do
      @validator.instance_variable_set(param, nil)

      expect {
        @validator.validate
      }.to raise_error(Google::Auth::TokenValidator::Error, "Validator was not properly initialized")
    end
  end

  it "fails when envelope contains non-matching certificate" do
    validator = Google::Auth::TokenValidator.new tokens[:no_matching_cert], @client_id

    expect {
      validator.validate
    }.to raise_error(
      Google::Auth::TokenValidator::Error,
      /No matching Google cert found for envelope/
    )
  end

  it "fails when the template is used too late" do
    validator = Google::Auth::TokenValidator.new tokens[:expired], @client_id

    expect {
      validator.validate
    }.to raise_error(Google::Auth::TokenValidator::Error, "Token used too late")
  end

  it "fails when the client ID is of invalid type" do
    validator = Google::Auth::TokenValidator.new @refreshed_id_token, :bogus_client_id

    expect {
      validator.validate
    }.to raise_error(Google::Auth::TokenValidator::Error, "Invalid client id(s)")
  end

  it "fails when the expected client ID doesn't match the provided one" do
    validator = Google::Auth::TokenValidator.new @refreshed_id_token, "not-a-real-client-ID"

    expect {
      validator.validate
    }.to raise_error(
      Google::Auth::TokenValidator::Error,
      "Wrong recipient - payload audience doesn't match required audience"
    )
  end

  it "fails when tampering has invalidated the signature" do
    validator = Google::Auth::TokenValidator.new tokens[:tampered], @client_id

    expect {
      validator.validate
    }.to raise_error(Google::Auth::TokenValidator::Error, "Token signature invalid")
  end

  # NOTE - this test should be run last, since it pollutes the validator class. This technique isn't
  # ideal, but I cannot actually trigger this check otherwise; tampering with the payload issuer
  # causes the signature check to fail prior to this.
  it "fails when issuer doesn't match expectations" do
    Google::Auth::TokenValidator::ISSUERS = %w(https://bogus.com).freeze
    validator = Google::Auth::TokenValidator.new @refreshed_id_token, @client_id

    expect {
      validator.validate
    }.to raise_error(Google::Auth::TokenValidator::Error, /Invalid issuer/)
  end
end
