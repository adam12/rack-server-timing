# frozen-string-literal: true
require "sequel"

module RackServerTiming
  module Sequel
    def log_duration(duration, message)
      RackServerTiming::Current.recorder.increment("DB", duration, "Database")

      super
    end

    def self.extended(base)
      return unless base.loggers.empty?

      require "logger"
      base.loggers = [Logger.new("/dev/null")]
    end
  end

  ::Sequel::Database.register_extension(:server_timing, RackServerTiming::Sequel)
end
