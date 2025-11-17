require "spec_helper"

RSpec.describe Emailverify::Request do
  before do
    Emailverify.reset!
  end

  it "raises when api_key is missing" do
    Emailverify.configure do |c|
      c.api_key = nil
    end

    expect { described_class.new }.to raise_error(Emailverify::AuthenticationError)
  end

  it "uses default base_url when not provided" do
    Emailverify.configure do |c|
      c.api_key = "key"
      # do not set base_url; default should be used
    end

    expect { described_class.new }.not_to raise_error
  end
end
