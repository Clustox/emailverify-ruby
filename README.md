# Emailverify Ruby Gem

emailverify is a small, object-oriented Ruby client for the EmailVerify.io API.

Features
- Simple configuration (only the API key is required by default)
- Clean wrapper methods: validate, valid?, and check_balance
- Abstracts HTTP details using Faraday

Quick start

1) Add to your Gemfile or install locally

```ruby
gem "emailverify", git: "https://github.com/Clustox/emailverify-ruby.git"
```


2) Configure (only api_key is strictly required)

```ruby
Emailverify.configure do |config|
  config.api_key = "YOUR_API_KEY"
end

request = Emailverify::Request.new
result = request.validate("jane@example.com")

if request.valid?("jane@example.com")
  puts "valid"
else
  puts "invalid"
end

balance = request.check_balance # or client.check_balance(batch_id)

# Validate example (EmailVerify.io v1)
# The gem will call:
# https://app.emailverify.io/api/v1/validate?key=<YOUR_API_KEY>&email=valid@example.com
# and return parsed JSON, for example:
# {
#   "email": "jhon123@gmail.com",
#   "status": "valid",
#   "sub_status": "permitted"
# }

# Modern usage (Response objects)
# The client now returns an `Emailverify::Response` wrapper with helper accessors.
Emailverify.configure do |c|
  c.apikey = ENV['EMAILVERIFY_API_KEY']
end

# Module-level convenience
resp = Emailverify.validate(email: 'jane@example.com')
puts resp.status            # => 'valid' (string)
puts resp.sub_status        # => 'permitted' or nil
puts resp.to_h              # => raw Hash if you need it

balance = Emailverify.check_balance
puts balance.api_status     # => 'enabled'
puts balance.available_credits

# Balance example (EmailVerify.io v2)
# The gem will call:
# https://app.emailverify.io/api/v2/check-account-balance?key=<YOUR_API_KEY>
# and return the parsed JSON, for example:
# {
#   "api_status": "enabled",
#   "available_credits": 16750
# }

```

Notes on endpoints
The gem ships with sensible defaults for endpoints, but your service may have different paths. You can pass an `endpoint:` option to each method or override the configured endpoints via `Emailverify.configure`.

Security
- The client will send the API key in an Authorization header for endpoints that expect it. The EmailVerify.io endpoints used by this gem (v1 validate and v2 check-account-balance) use the `key` query parameter, and the client passes this automatically for those methods.

Contributing
Pull requests welcome. Run tests with `bundle install && bundle exec rake`.

## License

Licensed under the [MIT](https://opensource.org/licenses/MIT) License — see the [LICENSE](./LICENSE) file for details.

