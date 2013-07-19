module Cumuli
  class App
    class ForemanProcess
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
        "HEROKU_ENV=#{env} RAILS_ENV=#{env} foreman start"
      end

      def log_file
        "#{log_dir}/#{env}.log"
      end

      def start
        @pid = fork do
          listen_for_signals
          $stdout.reopen(log_file)
          exec(command)
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

      def kill_children
        pids = PS.new.family(pid)
        pids.reverse.each do |p|
          begin
            Process.kill("KILL", p)
          rescue Errno::ESRCH
            puts "Small issue killing your child: #{p}; it looks to be dead"
          end
        end
      end
    end
  end
end
