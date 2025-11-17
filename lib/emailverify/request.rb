# frozen_string_literal: true

require "faraday"
require "json"

module Emailverify
  class Request
    DEFAULT_HEADERS = { "Content-Type" => "application/json" }.freeze

    def initialize(api_key: nil, base_url: nil, timeout: nil)
      @config = Emailverify.configuration
      @api_key = api_key || @config.api_key
      @base_url = base_url || @config.base_url
      @timeout = timeout || @config.timeout

      raise AuthenticationError, "API key missing" unless @api_key
      raise RequestError, "base_url must be configured" unless @base_url

      @conn = Faraday.new(url: @base_url) do |faraday|
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.options.timeout = @timeout
      end
    end

    # Validate a single email address. Returns parsed JSON from the API.
    # By default this uses EmailVerify.io's v1 endpoint which expects GET
    # with query params `key` and `email`, e.g.:
    # https://app.emailverify.io/api/v1/validate?key=yourapikey&email=valid@example.com
    # You can override the endpoint path via `endpoint:` if the API differs.
    def validate(email, endpoint: nil)
      path = endpoint || @config.endpoints[:validate]
      params = { key: @api_key, email: email }
      request(:get, path, params: params)
    end

    # Return boolean true/false for whether the email is valid.
    # For EmailVerify.io v1 the API returns `status` with values like
    # "valid", "invalid" and may include `sub_status` such as "permitted".
    # This method returns true when `status` equals "valid" (case-insensitive).
    def valid?(email, endpoint: nil)
      resp = validate(email, endpoint: endpoint)

      # Support Response objects or raw Hashes
      status_value = if resp.respond_to?(:status)
        resp.status
      elsif resp.is_a?(Hash)
        resp["status"] || resp[:status]
      else
        nil
      end

      return false unless status_value
      status_value.to_s.strip.downcase == "valid"
    end

    # Check balance or status of a completed batch. Accepts an id or options.
    # Check account balance. By default this calls the EmailVerify.io endpoint
    # /api/v2/check-account-balance and passes the API key as the `key` query param
    # (https://app.emailverify.io/api/v2/check-account-balance?key=<Your_API_Key>)
    # If your provider uses a different pattern you may pass `endpoint:` or
    # override `Emailverify.configuration.endpoints[:check_balance]`.
    def check_balance(batch_id = nil, endpoint: nil)
      path = endpoint || @config.endpoints[:check_balance]

      # If a batch_id is provided, append it to the path (useful for batch status
      # endpoints that accept an id as part of the path).
      if batch_id
        path = File.join(path, batch_id.to_s)
      end

      # EmailVerify.io expects the API key as query param `key` for this endpoint.
      params = { key: @api_key }

      request(:get, path, params: params)
    end

    # (auth_check endpoint removed) If you need a custom check you can call
    # `client.request(:get, path, params: { key: ... })` directly or supply the
    # endpoint to the high-level methods.

    private

    def request(method, path, json: nil, params: nil)
      raise RequestError, "path is required" unless path

      headers = DEFAULT_HEADERS.merge("Authorization" => "Bearer #{@api_key}")

      response = @conn.send(method) do |req|
        req.url path
        req.headers.update(headers)
        req.params.update(params) if params
        req.body = JSON.generate(json) if json
      end

      case response.status
      when 200..299
        parsed = parse_body(response.body)
        # Wrap parsed JSON hashes in a Response object for a nicer API
        return Emailverify::Response.new(parsed) if parsed.is_a?(Hash)
        parsed
      when 401, 403
        raise AuthenticationError, "authentication failed (status=#{response.status})"
      else
        raise RequestError, "request failed (status=#{response.status}): #{response.body}"
      end
    rescue Faraday::TimeoutError => e
      raise RequestError, "request timeout: #{e.message}"
    rescue Faraday::ConnectionFailed => e
      raise RequestError, "connection failed: #{e.message}"
    end

    def parse_body(body)
      return {} if body.nil? || body.strip.empty?
      JSON.parse(body)
    rescue JSON::ParserError
      raise UnexpectedResponseError, "Invalid JSON response"
    end

    def truthy_value?(val)
      return true if val == true
      return true if val.is_a?(String) && val.strip.downcase == "true"
      return true if val.is_a?(Numeric) && val.to_f > 0
      false
    end

    def falsy_value?(val)
      return true if val == false
      return true if val.nil?
      return true if val.is_a?(String) && val.strip.empty?
      return true if val.is_a?(Numeric) && val.to_f == 0
      false
    end
  end
end
