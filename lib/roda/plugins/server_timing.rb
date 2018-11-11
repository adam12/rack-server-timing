# frozen-string-literal: true

require "rack-server-timing/middleware"

class Roda
  module RodaPlugins
    module ServerTiming
      module InstanceMethods
        # Shorthand to the +RackServerTiming::Recorder+ instance
        def server_timing
          env["rack.server_timing"]
        end

        # Benchmark the provided block and return it's result
        def benchmark(name:, description: nil)
          result = nil

          server_timing.benchmark(name: name, description: description) do
            result = yield
          end

          result
        end

        # :nodoc:
        def render(*)
          benchmark(name: "Render") { super }
        end

        # :nodoc:
        def view(*)
          benchmark(name: "Render") { super }
        end
      end

      def self.configure(app)
        app.use RackServerTiming::Middleware
      end
    end

    register_plugin :server_timing, ServerTiming
  end
end
