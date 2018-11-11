require "minitest/autorun"
require "roda"

describe "Roda Plugin" do
  describe "with render plugin" do
    app = Class.new(Roda) do
      plugin :render
      plugin :server_timing

      route do |r|
        r.get "render" do
          render(inline: "Render")
        end

        r.get "view" do
          view(inline: "View", layout: { inline: "<%= yield %>" })
        end
      end
    end

    it "benchmarks #render" do
      response = Rack::MockRequest.new(app).get("/render")

      assert_equal "Render", response.body
      refute_empty response["Server-Timing"]
    end

    it "benchmarks #view" do
      response = Rack::MockRequest.new(app).get("/view")
      assert_equal "View", response.body
      refute_empty response["Server-Timing"]
    end
  end

  describe "without render plugin" do
    app = Class.new(Roda) do
      plugin :server_timing

      route do |r|
        "OK"
      end
    end

    it "loads successfully" do
      response = Rack::MockRequest.new(app).get("/")

      assert_equal "OK", response.body
    end
  end
end
