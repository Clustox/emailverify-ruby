require "spec_helper"

RSpec.describe Emailverify::Request do
  before do
    Emailverify.reset!
    Emailverify.configure do |c|
      c.api_key = "testkey"
    end
  end

  it "calls the v2 check-account-balance endpoint with key query param" do
    request = described_class.new

    stub_url = "https://app.emailverify.io/api/v2/check-account-balance"
    stub_request(:get, stub_url)
      .with(query: { 'key' => 'testkey' })
      .to_return(status: 200, body: JSON.generate({ "api_status" => "enabled", "available_credits" => 16750 }), headers: { 'Content-Type' => 'application/json' })

    resp = request.check_balance

    expect(resp).to be_a(Emailverify::Response)
    # prefer the Response helpers for balance
    expect(resp.api_status).to eq('enabled')
    expect(resp.available_credits).to eq(16750)

    expect(a_request(:get, stub_url).with(query: { 'key' => 'testkey' })).to have_been_made
  end
end
