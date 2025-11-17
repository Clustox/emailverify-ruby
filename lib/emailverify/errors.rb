# frozen_string_literal: true

module Emailverify
  class Error < StandardError; end
  class AuthenticationError < Error; end
  class RequestError < Error; end
  class UnexpectedResponseError < Error; end
end
