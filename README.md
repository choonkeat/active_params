# ActiveParams

Stop manually defining `strong_parameters` in each and every controller.

Whatever parameters that was used during `development` mode is considered permitted parameters for `production`. So automatically record them in `development` mode and simply apply `strong_parameters` in production.

aka No more [strong parameters falls!](https://twitter.com/JuanitoFatas/status/746228574592499712) 👌

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

### Rails.env.development?

During `development` mode, `active_params` will generate the appropriate strong parameters settings for each param (scoped to the current http method, controller_name and action_name)

For example, when you submit a form like this

```
Started POST "/users" for 127.0.0.1 at 2016-06-26 00:41:19 +0800
Processing by UsersController#create as HTML
  Parameters: {"utf8"=>"✓", "authenticity_token"=>"...", "user"=>{"name"=>"John", "avatar"=>"Face.png", "photos"=>["Breakfast.png", "Coffee.png"]}, "button"=>""}
```

`active_params` will create or update the `config/active_params.json` file with the settings

``` json
{
  "POST users/create": {
    "user": [
      "avatar",
      "name",
      {
        "photos": [

        ]
      }
    ]
  }
}
```

NOTE: see [the test](https://github.com/choonkeat/active_params/blob/a84e0ab41ee7a522c6c38ee1657cfb68bc4850e9/test/active_params_test.rb#L23-L57) for a more complicated example

### Rails.env.production? (and other modes)

In non-development mode, `active_params` will NOT update the `config/active_params.json` file.

It loads `config/active_params.json` and automatically perform the correct strong parameters setup for each request

``` ruby
params[:user] = params.require(:user).permit(:avatar, :name, photos: [])
```

So, in your controllers, you can simply reference `params[:user]` again!

``` ruby
def create
  @user = User.new(params[:user])
  if @user.save
    redirect_to @user, notice: 'User was successfully created.'
  else
    render :new
  end
end
```

### Workflow

When you create new features for your app & try them out in development mode, `config/active_params.json` will be automatically updated. When you commit your code, include the changes to `config/active_params.json` too.

### Static Customizations

You can add a `config/initializers/active_params.rb` file in your Rails app, and perform a global config like this

```ruby
ActiveParams.config do |config|
  config.writing = Rails.env.development?
  config.path    = "config/active_params.json"
  config.scope   = proc { |controller|
    "#{controller.request.method} #{controller.controller_name}/#{controller.action_name}"
  }
end
```

### Dynamic Customizations

Each controller may need its own config, e.g. some strong params are only permitted for certain current_user roles. For such controllers, use the `include ActiveParams.setup(...)` syntax instead

```ruby
class ApplicationController < ActionController::Base
  include ActiveParams.setup({
    path: "tmp/strong_params.json",
    writing: !Rails.env.production?,
    scope: proc {|ctrl|
      [ctrl.current_user.role, ActiveParams.scope.(ctrl)].join('@')
    },
  })
end
```

You can setup
- where the config file is stored
- if you want to write to the config file
- how should strong params be scoped

## LICENSE

MIT
