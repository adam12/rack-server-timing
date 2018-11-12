require "sequel"

module RackServerTiming
  module Sequel
    def log_duration(duration, message)
      RackServerTiming::Current.recorder.increment("DB", duration, "Database")

      super
    end
  end

  ::Sequel::Database.register_extension(:server_timing, RackServerTiming::Sequel)
end
