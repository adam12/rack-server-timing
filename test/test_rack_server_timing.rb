require "minitest/autorun"
require "rack-server-timing/middleware"
require "rack"

describe RackServerTiming::Middleware do
  it "sets server timing header" do
    app = Rack::Builder.new do
      use RackServerTiming::Middleware

      run ->(env) {
        env["rack.server_timing"].record("DB", 100)
        [200, {}, ["OK"]]
      }
    end

    response = Rack::MockRequest.new(app).get("/")
    assert response.has_header?("SERVER_TIMING"), "Server-Timing header missing"
  end
end

describe RackServerTiming::Recorder do
  recorder = RackServerTiming::Recorder.new

  describe "#header_value" do
    it "properly formats header value" do
      refute_nil recorder.header_value
    end
  end

  describe "#header_name" do
    it "has a value" do
      refute_nil recorder.header_name
    end
  end

  describe "#record" do
    it "passes args to Metric builder" do
      metric = recorder.record("DB", 100)
      assert_equal "DB", metric.name
      assert_equal 100, metric.duration
    end

    it "passes kwargs to Metric builder" do
      metric = recorder.record(name: "DB", duration: 100)
      assert_equal "DB", metric.name
      assert_equal 100, metric.duration
    end

    it "stores the Metric" do
      recorder.record("DB", 100)

      assert_equal 1, recorder.metrics.length
    end
  end
end

describe RackServerTiming::Metric do
  describe ".build" do
    it "accepts arguments" do
      metric = RackServerTiming::Metric.build("DB", 100)

      assert_equal "DB", metric.name
      assert_equal 100, metric.duration
    end

    it "accepts kwargs" do
      metric = RackServerTiming::Metric.build(name: "DB", duration: 100)

      assert_equal "DB", metric.name
      assert_equal 100, metric.duration
    end
  end

  describe "#formatted" do
    it "properly formatted output" do
      metric = RackServerTiming::Metric.new(name: "missedCache")
      assert_equal "missedCache", metric.formatted

      metric = RackServerTiming::Metric.new(name: "DB", duration: 100)
      assert_equal "DB;dur=100", metric.formatted

      metric = RackServerTiming::Metric.new(name: "DB", duration: 100, description: "Database")
      assert_equal %q|DB;dur=100;desc="Database"|, metric.formatted
    end
  end
end
