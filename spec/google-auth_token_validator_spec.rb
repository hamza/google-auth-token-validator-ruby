require "spec_helper"

RSpec.describe Google::Auth::TokenValidator do
  include_context "test data"

  it "has a version number" do
    expect(Google::Auth::TokenValidator::VERSION).not_to be nil
  end

  it "validates a token" do
    validator = Google::Auth::TokenValidator.new data[:id_token][:good], data[:client_id]
    expect(validator.validate).to eq(true)
  end
end
