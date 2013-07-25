module Cumuli
  class App
    class Spawner
      attr_reader :pid, :env, :log_dir

      def initialize(env, log_dir)
        @env = env
        @log_dir = log_dir
        ensure_log_dir_and_file
      end

      def ensure_log_dir_and_file
        FileUtils.mkdir_p(log_dir)
        FileUtils.touch(log_file)
      end

      def command
        "foreman start"
      end

      def log_file
        "#{log_dir}/#{env}.log"
      end

      def start
        @pid = fork do
          spawn(
            {
              'HEROKU_ENV' => env,
              'RAILS_ENV' => env
            },
            command,
            {
              out: $stdout.reopen(log_file),
              pgroup: true, # start a new process group
            }
          )
        end
      end

      def listen_for_signals
        Cumuli::App::SIGNALS.each do |signal|
          trap(signal) do
            puts "#{self.class}: trapped signal #{signal} in #{Process.pid} ... stopping"
            stop
          end
        end
      end

      def started?
        !!pid
      end

      def stop
        return if @killed_it
        kill_children
        @killed_it = true
        @pid = nil
      end

      def group_id
        PS.new.root_pid
      end

      def kill_children
        Process.kill('INT', -group_id) # kills the forked group
      end
    end
  end
end

