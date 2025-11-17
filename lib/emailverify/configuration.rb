# frozen_string_literal: true

module Emailverify
  class Configuration
    attr_accessor :api_key, :timeout, :logger, :endpoints
    attr_reader :base_url

    def initialize
      @api_key = nil
      # Base URL is fixed to the official EmailVerify.io host
      @base_url = "https://app.emailverify.io"
      @timeout = 10
      @logger = nil
      # endpoints can be overridden by the user to match their API paths
      @endpoints = {
        # EmailVerify.io single email validation endpoint (v1)
        validate: "/api/v1/validate",
        # EmailVerify.io check account balance endpoint (v2)
        check_balance: "/api/v2/check-account-balance"
      }
    end

    # ZeroBounce-style alias: allow `config.apikey = 'key'` to set api_key
    def apikey=(val)
      self.api_key = val
    end

    def apikey
      api_key
    end
  end
end
