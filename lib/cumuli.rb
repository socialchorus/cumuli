$stdout.sync = true

lib = File.expand_path(File.dirname(__FILE__))
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require "cumuli/cli"
require "cumuli/version"
