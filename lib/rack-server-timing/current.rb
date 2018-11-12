# frozen-string-literal: true
module RackServerTiming
  module Current
    def self.clear!
      Thread.current[:server_timing] = nil
    end

    def self.recorder=(recorder)
      Thread.current[:server_timing] = recorder
    end

    def self.recorder
      Thread.current[:server_timing]
    end
  end
end
