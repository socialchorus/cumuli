$stdout.sync = true

lib = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'logger'
require 'timeout'
require 'fileutils'
require 'yaml'

require "cumuli/facade"
require "cumuli/ps"
require "cumuli/waiter"
require "cumuli/cli"
require "cumuli/spawner"
require "cumuli/project_manager"
require "cumuli/version"
