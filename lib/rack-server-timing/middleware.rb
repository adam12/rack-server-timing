# frozen-string-literal: true
require_relative "recorder"
require_relative "current"

module RackServerTiming
  class Middleware
    def initialize(app)
      @app = app
    end

    def call(env)
      recorder = Recorder.new

      env["rack.server_timing"] = Current.recorder = recorder
      status, headers, response = @app.call(env)

      if (value = recorder.header_value) and not value.empty?
        headers[recorder.header_name] ||= value
      end

      [status, headers, response]
    ensure
      Current.clear!
    end
  end
end
