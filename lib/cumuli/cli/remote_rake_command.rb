module Cumuli
  class CLI
    class RemoteRakeCommand
      attr_reader :argv

      DIR_ENV = 'DIR='
      COMMAND_ENV= 'COMMAND='

      def initialize(argv)
        puts "argv: #{argv.inspect}"
        @argv = argv
      end

      def extract_env(env_var)
        found_arg = argv.detect{|arg| arg.include?(env_var)}
        found_arg && found_arg.gsub(env_var, '')
      end

      def dir
        extract_env(DIR_ENV)
      end

      def raw_command
        extract_env(COMMAND_ENV) || get_passed_command
      end

      def get_passed_command
        matched = argv.first.match(/\[(.*)\]/)
        (matched && matched[1]) || argv.first
      end

      def command
        Commander.new(raw_command).build
      end

      def perform
        Dir.chdir(dir) do
          puts "running #{command}, at #{dir}"
          Terminal.new(command).spawn
        end
      end
    end
  end
end
