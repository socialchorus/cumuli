module Strawboss
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
        puts command
        spawn_terminal(command)
      end
    end

    def listen_for_signals
      signals.each do |signal|
        Signal.trap(signal) do
          puts "caught #{signal} in strawboss"
          kill_processes
        end
      end
    end

    def processes
      @processes ||= []
    end

    def kill_processes
      puts "killing processes #{processes}"
      processes.each do |pid|
        puts "killing process #{pid}"
        Strawboss::Assassin.new(pid, 'SIGTERM').kill
      end
    end

    def signals
      ["SIGTERM", "SIGKILL", "SIGINT", "SIGHUP"]
    end

    def spawn_terminal(command)
      terminal = Terminal.new(command) do |stdin, stdout, pid|
        processes.push(pid)

        stdin.each { |line| print "#{args.name}: #{line}" }

        signals.each do |signal|
          trap(signal) do
            puts 'trapped signal in the terminal'
            Strawboss::Assassin.new(pid, signal).kill
          end
        end

        until stdin.eof?
          puts stdin.gets
        end
      end

      terminal.spawn
    end
  end
end

