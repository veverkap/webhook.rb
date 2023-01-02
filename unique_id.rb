require 'securerandom'

module Rack
  class RequestId
    REQUEST_ID = "HTTP_X_REQUEST_ID"

    def self.current
      Thread.current.thread_variable_get(:request_id)
    end

    # Gets the request ID from the environment.
    #
    # env - The request Environment.
    #
    # Returns the ID String.
    def self.get(env)
      env[REQUEST_ID]
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      began_at = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)

      request_id = external_request_id(env) || internal_request_id
      env[REQUEST_ID] = request_id
      Thread.current.thread_variable_set(:request_id, request_id)

      status, headers, body = @app.call(env)
      finished_at = ::Process.clock_gettime(::Process::CLOCK_MONOTONIC)
      elapsed = finished_at - began_at

      headers["X-Request-Id"] = request_id
      headers["Server-Timing"] = "app;dur=#{elapsed}"
      [status, headers, body]
    end

    private

    def external_request_id(env)
      request_id = env[REQUEST_ID]
    end

    def internal_request_id
      SecureRandom.uuid
    end
  end
end