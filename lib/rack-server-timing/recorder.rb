# frozen-string-literal: true
require_relative "metric"

module RackServerTiming
  class Recorder
    attr_reader :metrics

    def initialize
      @metrics = {}
    end

    def increment(name = nil, duration = nil, description = nil, **kwargs)
      name = kwargs[:name] if name.nil?
      duration = kwargs[:duration] if duration.nil?
      description = kwargs[:description] if description.nil?

      if (metric = metrics[name])
        metric.increment(duration)
      else
        metric = Metric.new(name: name, duration: duration, description: description)
        metrics[name] = metric
      end
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
