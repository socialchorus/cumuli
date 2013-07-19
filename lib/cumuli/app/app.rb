module Cumuli
  class App
    DEFAULT_WAIT_TIME = 5 #120
    SIGNALS = ['TERM', 'INT', 'HUP']

    attr_accessor :env, :wait_time, :app_dir, :log_dir

    def initialize(options={})
      @env = options[:env]
      @wait_time = options[:wait_time]
      @log_dir = options[:log_dir] || "#{Dir.pwd}/log"
      @app_dir = options[:app_dir] || Dir.pwd
    end

    def start
      return if foreman_process.started?

      Dir.chdir(app_dir) do 
        listen_for_signals
        logger.print "Starting ..."
        foreman_process.start
        wait_for_apps if wait?
      end
    end

    def logger
      @logger = StdoutLogger.new
    end

    def foreman_process
      @termial ||= ForemanProcess.new(env, log_dir)
    end

    def apps
      @apps ||= Procs.new(app_dir).apps
    end

    def pid
      foreman_process.pid
    end

    def wait?
      wait_time && wait_time > 0
    end

    def listen_for_signals
      SIGNALS.each do |signal|
        trap(signal) do
          stop
        end
      end
    end

    def app_ports
      apps.map.values.compact
    end

    def wait_for_apps
      logger.add_space
      apps.each do |app|
        log_and_wait(app)
      end
      logger.add_space
    end

    def log_and_wait(app)
      timeout = wait_time || DEFAULT_WAIT_TIME
      logger.print "Waiting for app named '#{app.name}' at #{app.url}"
      app.wait(timeout)
      logger.print "Application '#{app.name}' on #{app.url} available"
      logger.add_space
    rescue Exception => e
      stop
      raise e
    end

    def stop
      if foreman_process.started?
        foreman_process.stop
        @foreman_process = nil
      end
    end
  end
end
