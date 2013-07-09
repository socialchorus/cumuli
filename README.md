# Cumuli

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

    gem 'cumuli'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cumuli

## Usage

### Command line interface for Procfiles

Strawboss has a command-line interface that can be used via
a parent Procfile. This allows procfiles to point to other
applications, with their own Procfiles. This is what the parent
 Procfile might look like:

    rails_app_1: cumuli ../rails_app_1 -p 3000
    rails_app_2: cumuli ../rails_app_2 -p 4000
    node_app: cumuli ../node_app -p 5000

Currently, cumuli works via .rvmrc files. Ruby version files are not
yet implemented, but cumuli will use the rvm environment described in
the .rvmrc file.

### App for intergration testing

Running a set of applications in tandem is great for sandboxing, but
ultimately we need to do integration testing across services and apps.
Cumuli comes with an application component that can be run in test
framework.

    # Both initialization argument are optional
    #   first argument: environment
    #   second argument: whether to try to establish a connection to 
    #     each of the apps with a port before continuing in the thread
    app = Cumuli::App.new('test', false)

    app.start # starts all the applications and services in the Procfile

    app.pid # pid of top level foreman process

    app.wait_for_app(5000) # wait for app on port 5000
    # alternately app.wait_for_apps will wait for every app in the
    # Procfile that has a port
    # 
    # or just don't pass false into the initializer!

    app.stop # gracefully kills all the related processes

## Known Issues

If you start the Cumuli app and stop it the first time, it will successfully start and stop all processes.  However, if you use the same Cumuli app class to
start and stop the processes again, it will fail to stop any of the
processes.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
