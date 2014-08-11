module Cumuli
  class CLI
    class Commander
      attr_reader :command

      def initialize(command)
        @command = command
      end

      def build
        "#{rvm_preface} #{command}"
      end

      def rvm_preface
        "ruby"
      end

      def rvmrc_descriptor
        './.ruby-version'
      end

      def rvmrc?
        File.exist?(rvmrc_descriptor)
      end

      def rvm_version
        File.read(rvmrc_descriptor)
      end
    end
  end
end
