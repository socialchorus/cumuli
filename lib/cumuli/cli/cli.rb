module Cumuli
  class CLI
    def run
      spawn_app
    end

    def args
      @args ||= Args.new(ARGV.dup)
    end

    def spawn_app
      listen_for_signals

      Dir.chdir(args.dir) do
        command = Commander.new(args).build
        puts "starting ... #{command}"
        spawn_terminal(command)
      end
    end

    def signals
      # these are the signals used by Foreman
      ['TERM', 'INT', 'HUP']
    end

    def listen_for_signals
      signals.each do |signal|
        Signal.trap(signal) do
          kill_process
        end
      end
    end

    def kill_process
      Process.kill('INT', Process.pid)
    end

    def spawn_terminal(command)
      Terminal.new(command).spawn
    end
  end
end

