# Strawboss

In the land of Service Oriented Architecture, knowing whether everything
is communicating properly is hard. Strawboss is a tool for running many
foreman runnable applications, in different directories, from a single
process. This is a great way to see if the services that are distributed
over Heroku apps, actually are working together as expected.

We use strawboss as a way to reality check in a full development
sandbox; to write integration specs; and as a staging ground for broad
ranging deploy scripts or data migrations.

See usage for more details.


## Installation

Add this line to your application's Gemfile:

    gem 'strawboss'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install strawboss

## Usage

Strawboss is primarily a command-line interface that can be used via
a parent Procfile that can point to other applications, with their own
Procfiles. This is what the parent Procfile might look like:

    rails_app_1: strawboss ../rails_app_1 -p 3000
    rails_app_2: strawboss ../rails_app_2 -p 4000
    node_app: strawboss ../node_app -p 5000

Currently, strawboss works via .rvmrc files. Ruby version files are not
yet implemented, but strawboss will use the rvm environment described in
the .rvmrc file.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
