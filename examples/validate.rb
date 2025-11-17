#!/usr/bin/env ruby
require_relative "../lib/emailverify"

Emailverify.configure do |c|
  c.apikey = ENV['EMAILVERIFY_API_KEY'] || abort("Set EMAILVERIFY_API_KEY to run this example")
end

email = ARGV[0] || 'valid@example.com'

puts "Validating: #{email} against #{Emailverify.configuration.base_url}"
resp = Emailverify.validate(email: email)
puts "Response object:"
p resp
puts "Status: #{resp.status}"
puts "Sub-status: #{resp.sub_status}"
puts "Raw Hash:"
p resp.to_h

puts "\nBalance:"
bal = Emailverify.check_balance
p bal
puts "API status: #{bal.api_status}, credits: #{bal.available_credits}"
