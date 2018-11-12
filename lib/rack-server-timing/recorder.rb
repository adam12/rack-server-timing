# frozen-string-literal: true
require "benchmark"
require_relative "metric"

module RackServerTiming
  class Recorder
    attr_reader :metrics

    def initialize
      @metrics = {}
    end

    ##
    # Increment the metric of :name: by :duration:, creating the metric if
    # it did not already exist.
    #
    # Accepts arguments as positional arguments or keyword arguments.
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

    ##
    # Record the metric of :name: with :duration: and optionally :description:.
    #
    # Accepts arguments as positional arguments or keyword arguments.
    def record(name = nil, duration = nil, description = nil, **kwargs)
      name ||= kwargs[:name]
      duration ||= kwargs[:duration]
      description ||= kwargs[:description]

      metrics[name] = Metric.new(
        name: name,
        duration: duration,
        description: description
      )
    end

    ##
    # Record the metric of :name: with an optional :description:, evaluating the
    # provided block for :duration:.
    #
    # Accepts arguments as positional arguments or keyword arguments.
    def benchmark(name = nil, description = nil, **kwargs, &block)
      name ||= kwargs[:name]
      description ||= kwargs[:description]
      duration = Benchmark.realtime { block.call }

      metrics[name] = Metric.new(
        name: name,
        duration: duration,
        description: description,
      )
    end

    def header_name
      "Server-Timing"
    end

    def header_value
      metrics.map {|_name, metric| metric.formatted }.join(", ")
    end
  end
end
