# Courier

An free, open source minimalistic alternative to Firebase Invite or branch.io
Send deep links to your mobile users that survive the installation process.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'courier'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install courier

## Configure

The courier gem adds a middleware that handles the deep link redirection and user identification either before it reaches your application.

To configure add the middleware to your stack wherever it makes more sense for you.
Options you can provide to the configuration blocks are:

- *deep_link_base*: _required_ This is the name of your mobile app to redirect the deep links.
- *mounted_as: Default*: _optional_ Default(courier). This are the mounted url for currier links.

### Ruby On Rails

Add the following config block to an initializer

```
Courier.configure do |config|
  config.deep_link_base = 'my-app' # required
  # config.mounted_as = 'deep-links-base' # optional
end
```
Add the middleware to your stack in `config/application.rb`

```
  config.middleware.use Courier::Middleware`
```

### Other Rack Applications

Courier is built on top of Rack so any Rack project can integrate it. Simply make sure you add `Courier::Middleware` to your rack stack and run the configure block when starting your server.

## Usage

### Deep linking to your app

After set up simply send links to your users that match your `mounted_at` directory IE: http://yourdomain.com/courier/invite?friend_id=someid&invitation_id=otherid

Users that follow the link from mobile phones will be redirected to a deep link with the form

`<deep_link_base>://invite?friend_id=someid&invitation_id=otherid`

This open to possible paths: *New users* (users that don't have your app), *Existing Users*

### Existing users

Nothing to do here. Just handle the deep link as you always do on your iOS or Android application

### New users

One of the challenges courier attempts to solve is the deep link surviving the install process.
By default deep links will redirect the user to open your app or install it on the appropriate store.
After downloading and installing your app, when they open the app they won't get the content they would have gotten if they followed the deep link having the app installed the first time.
To Handle that simply do this at some time when loading your app.

Make a request

`GET http://<your_app_url>/<mounted_at>/check`

This request will respond with:

- 404: When courier is unable to match the user with a user that followed a deep link recently
- 200: JSON body response with the information of the request previously done by the user.

Sample response:

```
{
  "deep_link_path" : "<the_followed_path>"
  "params" : [
    { "<parameter_name>": "<parameter_value_string>" },
    ...
  ]
}
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rootstrap/courier. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Courier project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/courier/blob/master/CODE_OF_CONDUCT.md).
