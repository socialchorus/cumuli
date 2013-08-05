module Cumuli
  class CLI
    class RemoteCommander
      attr_reader :raw_command, :dir

      def initialize(command, dir)
        @raw_command = command
        @dir = dir
      end

      def command
        Commander.new(raw_command).build
      end

      def perform
        Dir.chdir(dir) do
          Terminal.new(command).spawn
        end
      end
    end
  end
end
