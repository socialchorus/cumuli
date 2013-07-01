$stdout.sync = true

lib = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "strawboss/args"
require "strawboss/assassin"
require "strawboss/cli"
require "strawboss/commander"
require "strawboss/terminal"
require "strawboss/version"


module Strawboss
end
