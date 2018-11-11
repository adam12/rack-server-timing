# frozen-string-literal: true
module RackServerTiming
  class Metric
    attr_reader :shortname
    attr_reader :duration
    attr_reader :description

    def initialize(shortname:, duration: nil, description: nil)
      @shortname = shortname
      @duration = duration
      @description = description
    end

    def formatted
      String.new(shortname).tap do |output|
        output << %Q|;dur=#{duration}|       if duration
        output << %Q|;desc="#{description}"| if description
      end
    end

    def self.build(*args, **kwargs)
      shortname = nil
      duration = nil
      description = nil

      if not args.empty?
        shortname = args.shift
        duration = args.shift
      end

      if not kwargs.empty?
        shortname = kwargs[:shortname]
        duration = kwargs[:duration]
        description = kwargs[:description]
      end

      new(shortname: shortname, duration: duration, description: description)
    end
  end
end
