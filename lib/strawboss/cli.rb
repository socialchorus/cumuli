$stdout.sync = true

require_relative "terminal"
require_relative "args"
require_relative "commander"
#require_relative "assassin"

module Strawboss
  class CLI
    def run
      spawn_app
    end

    def args
      @args ||= Args.new(ARGV.dup)
    end

    def spawn_app
      Dir.chdir(args.dir) do
        command = Commander.new(args).build
        puts command
        spawn_terminal(command)
      end
    end

    def spawn_terminal(command)
      terminal = Terminal.new(command) do |stdin, stdout, pid|
        stdin.each { |line| print "#{args.name}: #{line}" }

        until stdin.eof?
          puts stdin.gets
        end
      end

      terminal.spawn
    end
  end
end

