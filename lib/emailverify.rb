# frozen_string_literal: true

require_relative "emailverify/version"
require_relative "emailverify/configuration"
require_relative "emailverify/errors"
require_relative "emailverify/request"
require_relative "emailverify/response"

module Emailverify
  class << self
    # Configure the gem using a block:
    #
    # Emailverify.configure do |config|
    #   config.apikey = "xxx"
    # end
    def configure
      yield configuration if block_given?
      configuration
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def reset!
      @configuration = Configuration.new
    end

    # Convenience client helper — builds a client using current configuration
    def request
      @request ||= Request.new(api_key: configuration.api_key, base_url: configuration.base_url, timeout: configuration.timeout)
    end

    def validate(email, endpoint: nil)
      request.validate(email, endpoint: endpoint)
    end

    def valid?(email, endpoint: nil)
      request.valid?(email, endpoint: endpoint)
    end

    def check_balance(batch_id = nil, endpoint: nil)
      request.check_balance(batch_id, endpoint: endpoint)
    end

    # Load configuration from environment variables; helpful for CLI/CI use.
    # EMAILVERIFY_API_KEY and EMAILVERIFY_BASE_URL are supported, but base_url
    # will be ignored and remain the fixed app.emailverify.io host per design.
    def configure_from_env(env = ENV)
      configuration.api_key ||= env["EMAILVERIFY_API_KEY"]
      # ignore env base_url to keep fixed host; but store if present
      configuration
    end
  end
end

