module Cumuli
  module ProjectManager
    class Project
      DEFAULT_WAIT_TIME = 10
      LOCALHOST = '127.0.0.1'

      attr_reader :name, :database_config, :database_sample_config, :port, :path,
        :repository, :type, :setup_scripts, :wait_time, :domain
      
      def initialize(name, opts)
        @name = name

        @repository = opts['repository']
        @path = opts['path'] || "./#{name}"
        @port = opts['port']
        @type = opts['type'] || 'app'
        @wait_time = opts['wait_time'] || DEFAULT_WAIT_TIME
        @domain = opts['domain'] || '127.0.0.1'

        @database_config = opts['database_config'] || []
        @database_sample_config = opts['database_sample_config'] || []
        @setup_scripts = opts['setup_scripts'] || []

        @database_config = [@database_config] unless @database_config.is_a?(Array)
        @database_sample_config = [@database_sample_config] unless @database_sample_config.is_a?(Array)
      end

      def wait?
        type == 'app' && (wait_time && wait_time > 0) && (port || domain != LOCALHOST)
      end

      def wait_for_start
        return unless wait?
        Waiter.new("Unable to start #{name}").wait_until(wait_time) { socket_available? }
      end

      def wait_for_stop
        return unless wait?
        Waiter.new("Unable to stop #{name}").wait_until(wait_time) { !socket_available? }
      end

      def socket_available?
        TCPSocket.new(domain, port)
        true
      rescue Errno::ECONNREFUSED
        false
      end

      def url
        "http://#{domain}#{port ? ":#{port}" : ''}"
      end

      def database_sample_paths
        database_sample_config.map { |config_path| "#{path}/#{config_path}" }
      end

      def database_config_paths
        database_config.map { |config_path| "#{path}/#{config_path}" }
      end

      def database_configured?(path)
        File.exist?(path)
      end

      def write_database_config!
        database_config_paths.each_with_index do |config_path, i|
          FileUtils.cp(database_sample_paths[i], config_path)
        end
      end

      def write_database_config
        database_config_paths.each_with_index do |config_path, i|
          FileUtils.cp(database_sample_paths[i], config_path) unless configured?(config_path)
        end
      end

      def to_procfile
        send("#{type}_to_procfile") rescue ''
      end

      def app_to_procfile
        "#{name}: cumuli #{path} -p #{port}\n"
      end

      def service_to_procfile
        "#{name}: cumuli #{path}\n"
      end

      def submodule_init
        system "git submodule add #{repository} #{path}" if repository
      end

      def setup
        # checkout master, because sometimes on setup no branch is
        # checked out
        CLI::RemoteCommand.new(['git checkout master', "DIR=#{path}"])

        write_database_config

        setup_scripts.each do |script|
          CLI::RemoteCommand.new([script, "DIR=#{path}"]).perform
        end
      end
    end
  end
end
