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

  it "has a version number" do
    expect(Google::Auth::TokenValidator::VERSION).not_to be nil
  end

  it "validates a token" do
    validator = Google::Auth::TokenValidator.new @refreshed_id_token, ENV["TEST_CLIENT_ID"]
    expect(validator.validate).to eq(true)
  end
end
