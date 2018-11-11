require_relative "lib/rack-server-timing/middleware"

use RackServerTiming::Middleware

run ->(env) {
  env["rack.server_timing"].record("DB", 100, "Database")
  [200, {}, ["OK"]]
}
