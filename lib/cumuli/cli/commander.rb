module Cumuli
  class CLI
    class Commander
      attr_reader :args

      def initialize(args)
        @args = args
      end

      def build
        "#{rvm_preface} foreman start #{args.foreman_options}"
      end

      def rvm_preface
        "rvm ruby-#{rvm_version} exec" if rvmrc?
      end

      def rvmrc_descriptor
        './.rvmrc'
      end

      def rvmrc?
        File.exist?(rvmrc_descriptor)
      end

      def rvm_version
        File.read(rvmrc_descriptor).match(/(\d\.\d\.\d@\w+)/)[0]
      end
    end
  end
end
