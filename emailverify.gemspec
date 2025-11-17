# frozen_string_literal: true

Gem::Specification.new do |spec|
  spec.name          = "emailverify"
  spec.version       = Emailverify::VERSION rescue "0.1.0"
  spec.authors       = ["Salman Aslam"]
  spec.email         = ["you@example.com"]

  spec.summary       = "Ruby wrapper for the EmailVerify.io API"
  spec.description   = "A small, object-oriented Ruby client for the EmailVerify.io service."
  spec.homepage      = "https://github.com/yourname/emailverify"
  spec.license       = "MIT"

  spec.required_ruby_version = '>= 2.7.0'

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").select { |f| f =~ /^(lib|README|LICENSE|Rakefile|emailverify\.gemspec)/ }
  rescue
    Dir["lib/**/*"] + %w[README.md LICENSE Rakefile emailverify.gemspec]
  end

  # 👉 Fix open-ended dependency warnings
  spec.add_runtime_dependency "faraday", "~> 1.0"
  spec.add_runtime_dependency "json", "~> 2.0"

  # 👉 Dev dependency also fixed
  spec.add_development_dependency "rspec", "~> 3.0"
end
