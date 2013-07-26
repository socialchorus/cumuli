module Cumuli
  module Spawner
    class App
      SIGNALS = ['TERM', 'INT', 'HUP']

      attr_accessor :env, :app_dir, :log_dir

      def initialize(options={})
        @env = options[:env]
        @log_dir = options[:log_dir] || "#{Dir.pwd}/log"
        @app_dir = options[:app_dir] || Dir.pwd
      end

      def start
        return if foreman_process.started?

        Dir.chdir(app_dir) do
          listen_for_signals
          logger.print "Starting ..."
          foreman_process.start
          wait_for_apps
        end
      end

      def stop
        if foreman_process.started?
          foreman_process.stop
          wait_for_apps('stop')
          @foreman_process = nil
        end
      end

      def logger
        @logger = StdoutLogger.new
      end

      def foreman_process
        @foreman_process ||= Spawner::ForemanProc.new(env, log_dir)
      end

      def apps
        @apps ||= ProjectManager::Manager.new(app_dir).projects
      end

      def process_pids
        PS.new.family
      end

      def pid
        foreman_process.group_id
      end

      def listen_for_signals
        SIGNALS.each do |signal|
          trap(signal) do
            puts "#{self.class}: trapped signal #{signal} in #{Process.pid} ... stopping"
            stop
          end
        end
      end

      def wait_for_apps(direction = 'start')
        logger.add_space
        apps.each do |app|
          log_and_wait(app, direction)
        end
        logger.add_space
      end

      def log_and_wait(app, direction)
        logger.print "#{direction}: waiting for app named '#{app.name}' at #{app.url}"
        app.send("wait_for_#{direction}")
        logger.print "#{direction}: application '#{app.name}' on #{app.url} complete"
        logger.add_space
      rescue Exception => e
        stop
        raise e
      end
    end
  end
end
