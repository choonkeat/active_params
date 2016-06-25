# ActiveParams

Stop manually defining `strong_parameters` in each and every controller.

Automatically record the necessary `strong_parameters` settings when you use your app during development mode.

The `strong_parameters` will automatically apply.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'active_params'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install active_params

## Usage

Include the `ActiveParams` module into your controller, e.g.

```ruby
class ApplicationController < ActionController::Base
  include ActiveParams
end
```

## LICENSE

MIT
