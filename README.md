# Server Timing for Rack

Easily record and emit Server-Timing headers in your Rack applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "rack-server-timing"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-server-timing

## Usage in a Rack application

Simply require and add middleware:

```ruby
# config.ru
require "rack-server-timing/middleware"

use RackServerTiming::Middleware

run ->(env) {
  [200, {}, ["It Works!"]]
}
```

And then record your metrics:

```ruby
env["rack.server_timing"].record("DB", 200)
```

## Usage in a Roda application

Enable the plugin `server_timing` after `render` (if you wish to have the rendering profiled automatically).

```ruby
class App < Roda
  plugin :render # Optional
  plugin :server_timing
end
```

A convenient `server_timing` helper is available to quickly `record` or `benchmark`
timing values.

## Sequel timing

Enable the `server_timing` extension in your database instance. This extension will automatically create a
null logging instance if there is no logging configured so there _may_ be a small performance hit.

```ruby
DB = Sequel.connect

DB.extension :server_timing
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/adam12/rack-server-timing.

I love pull requests! If you fork this project and modify it, please ping me to see
if your changes can be incorporated back into this project.

That said, if your feature idea is nontrivial, you should probably open an issue to
[discuss it](http://www.igvita.com/2011/12/19/dont-push-your-pull-requests/)
before attempting a pull request.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
