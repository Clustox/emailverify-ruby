require "spec_helper"

RSpec.describe Emailverify::Request do
  before do
    Emailverify.reset!
    Emailverify.configure do |c|
      c.api_key = "testkey"
      # use default base_url (https://app.emailverify.io)
    end
  end

  it "calls the v1 validate endpoint with key and email and returns parsed json" do
    client = described_class.new

    stub_url = "https://app.emailverify.io/api/v1/validate"
    stub_request(:get, stub_url)
      .with(query: hash_including({ 'key' => 'testkey', 'email' => 'valid@example.com' }))
      .to_return(status: 200, body: JSON.generate({ "email" => "jhon123@gmail.com", "status" => "valid", "sub_status" => "permitted" }), headers: { 'Content-Type' => 'application/json' })

    resp = client.validate('valid@example.com')
    expect(resp).to be_a(Emailverify::Response)
    expect(resp.status).to eq('valid')
    expect(client.valid?('valid@example.com')).to eq(true)
  end
end
