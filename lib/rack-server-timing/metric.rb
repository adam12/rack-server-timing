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

    def formatted
      String.new(name).tap do |output|
        output << %Q|;dur=#{duration}|       if duration
        output << %Q|;desc="#{description}"| if description
      end
    end

    def self.build(*args, **kwargs)
      name = nil
      duration = nil
      description = nil

      if not args.empty?
        name = args.shift
        duration = args.shift
      end

      if not kwargs.empty?
        name = kwargs[:name]
        duration = kwargs[:duration]
        description = kwargs[:description]
      end

      new(name: name, duration: duration, description: description)
    end
  end
end
