[![Code Climate](https://codeclimate.com/github/socialchorus/cumuli.png)](https://codeclimate.com/github/socialchorus/cumuli)

# Cumuli

In the land of Service Oriented Architecture, knowing whether everything
is communicating properly is hard. Cumuli is a tool for running many
foreman runnable applications, in different directories, from a single
process. This is a great way to see if the services that are distributed
over Heroku apps, actually are working together as expected.

We use cumuli as a way to reality check in a full development
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

Cumuli has a command-line interface that can be used via
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
    app = Cumuli::Spawner::App.new('test', false)

    app.start # starts all the applications and services in the Procfile

    app.pid # pid of top level foreman process

    app.wait_for_app(5000) # wait for app on port 5000
    # alternately app.wait_for_apps will wait for every app in the
    # Procfile that has a port
    #
    # or just don't pass false into the initializer!

    app.stop # gracefully kills all the related processes

### Running command line tools in remote directories

When working with a whole series of apps and processes, developers will need to run remote tasks that use that app's ruby version.
Cumuli has a solution, rake tasks that can be run in those remote locations:

    rake cumuli:remote['rake db:migrate RAILS_ENV=test'] DIR=../../mactivator

The argument passed into the square brackets is the command that will be run in the directory with its Ruby environment. The DIR environmental
variable is where this command will be performed.

### Other useful rake tasks

Sometimes things go wrong in the spinning up and spinning down of child processes. There are two rake files for inspecting and killing proceses that
are likely related to cumuli.

    rake cumuli:ps # shows a list of all the related processes

    rake cumuli:kill # kills all those processes shown above

## Known Issues

* An occasional orphan will be left around, still debugging
* Mechanism for alerting spawner app that the foreman process has killed
  children needs to be faster and more direct

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
