# frozen-string-literal: true
require_relative "metric"

module RackServerTiming
  class Recorder
    attr_reader :metrics

    def initialize
      @metrics = {}
    end

    def record(*args)
      metric = Metric.build(*args)
      metrics[metric.name] = metric
    end

    def benchmark(*args, &block)
      metric = Metric.build_realtime(*args, &block)
      metrics[metric.name] = metric
    end

    def header_name
      "Server-Timing"
    end

    def header_value
      metrics.map {|_name, metric| metric.formatted }.join(", ")
    end
  end
end
