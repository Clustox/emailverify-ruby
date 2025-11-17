# frozen_string_literal: true

require "time"

module Emailverify
  # Generic Response wrapper for Emailverify API responses.
  #
  # Provides a V1Response module with common helpers similar to
  # the ZeroBounce response structure (status, sub_status, disposable?, ...).
  # Use by wrapping a parsed JSON Hash:
  #
  # resp = Emailverify::Response.new(parsed_json)
  # resp.status
  class Response
    attr_reader :body

    def initialize(body)
      # normalize keys to strings for convenient access
      @body = (body || {}).each_with_object({}) { |(k, v), h| h[k.to_s] = v }
    end

    # Return underlying hash
    def to_h
      @body.dup
    end

    # Minimal EmailVerify-specific helpers. This gem's API response shape
    # differs from ZeroBounce; expose small, explicit accessors instead of
    # mirroring ZeroBounce internals.

    # Email address returned by the API (if present)
    def email
      @email ||= @body["email"] || @body["email_address"]
    end

    # Status field as returned by the API (string)
    def status
      @status ||= @body["status"]
    end

    # Sub-status (string) if present
    def sub_status
      @sub_status ||= @body["sub_status"] || @body["sub-status"] || @body["substatus"]
    end

    # For balance responses: api_status
    def api_status
      @api_status ||= @body["api_status"]
    end

    # For balance responses: available_credits as Integer
    def available_credits
      val = @body["available_credits"] || @body["availableCredits"] || @body["credits"]
      val.nil? ? nil : val.to_i
    end

    # Generic accessor by key
    def [](key)
      @body[key.to_s]
    end
  end
end
