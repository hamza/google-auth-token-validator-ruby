require "coveralls"
Coveralls.wear!

require "bundler/setup"
require "yaml"
require "json"
require "googleauth/token_validator"

unless ENV["TRAVIS"]
  require "dotenv"
  Dotenv.load File.join(__dir__, "..", ".env")
end

RSpec.shared_context "test data", :shared_context => :metadata do
  yaml = YAML.load_file File.join(__dir__, "data.yml")
  let(:data) { JSON.parse(yaml.to_json, symbolize_names: true) }
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include_context "test data", :include_shared => true
end
