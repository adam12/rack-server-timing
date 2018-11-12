require "minitest/autorun"
require "sequel"
require "rack"
require "logger"

describe "Sequel DB extension" do
  app = Rack::Builder.new do
    use RackServerTiming::Middleware

    run ->(env) {
      db = Sequel.connect("mock://")
      db.loggers = [Logger.new("/dev/null")]
      db.extension :server_timing

      2.times { db[:table].to_a }

      [200, {}, ["OK"]]
    }
  end

  it "records time of queries" do
    response = Rack::MockRequest.new(app).get("/")

    refute_empty response["Server-Timing"]
  end
end
