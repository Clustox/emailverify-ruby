require "bundler/setup"
require "emailverify"
require "webmock/rspec"

RSpec.configure do |config|
  WebMock.disable_net_connect!(allow_localhost: true)
  config.example_status_persistence_file_path = ".rspec_status"
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
