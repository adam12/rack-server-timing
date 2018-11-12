# frozen-string-literal: true
module RackServerTiming
  class Metric
    attr_reader :name
    attr_reader :duration
    attr_reader :description

    def initialize(name:, duration: nil, description: nil)
      @name = name
      @duration = duration
      @description = description
    end

    def increment(delta)
      @duration += delta
      self
    end

    def formatted
      String.new(name).tap do |output|
        output << %Q|;dur=#{duration}|       if duration
        output << %Q|;desc="#{description}"| if description
      end
    end
  end
end
