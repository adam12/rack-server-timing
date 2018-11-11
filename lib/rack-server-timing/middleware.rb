# frozen-string-literal: true
require_relative "recorder"

module RackServerTiming
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      env["rack.server_timing"] = recorder = Recorder.new
      status, headers, response = @app.call(env)

      if (value = recorder.header_value) and not value.empty?
        headers[recorder.header_name] ||= value
      end

      [status, headers, response]
    end
  end
end
