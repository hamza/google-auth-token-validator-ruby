require "spec_helper"
require "net/http"
require "uri"
require "pry"

TOKEN_REFRESH_URL = URI("https://www.googleapis.com/oauth2/v4/token")

RSpec.describe Google::Auth::TokenValidator do
  include_context "test data"

  before :all do
    response = Net::HTTP.post_form(
      TOKEN_REFRESH_URL,
      {
        client_id: ENV["TEST_CLIENT_ID"],
        client_secret: ENV["TEST_CLIENT_SECRET"],
        refresh_token: ENV["REFRESH_TOKEN"],
        grant_type: "refresh_token"
      }
    )

    @refreshed_id_token = JSON.parse(response.body, symbolize_names: true)[:id_token]
  end

  before :each do
    @validator = Google::Auth::TokenValidator.new @refreshed_id_token, ENV["TEST_CLIENT_ID"]
  end

  it "has a version number" do
    expect(Google::Auth::TokenValidator::VERSION).not_to be nil
  end

  it "validates a token" do
    expect(@validator.validate).to be(true)
  end

  it "fails when initialized w/out a token consisting of 3 period-delimited segments" do
    expect {
      Google::Auth::TokenValidator.new "not.token", ENV["TEST_CLIENT_ID"]
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
    validator = Google::Auth::TokenValidator.new data[:no_matching_cert], ENV["TEST_CLIENT_ID"]

    expect {
      validator.validate
    }.to raise_error(Google::Auth::TokenValidator::Error, /No matching Google cert found for envelope/)
  end

  it "fails when the template is used too late" do
    validator = Google::Auth::TokenValidator.new data[:expired], ENV["TEST_CLIENT_ID"]

    expect {
      validator.validate
    }.to raise_error(Google::Auth::TokenValidator::Error, "Token used too late")
  end
end
