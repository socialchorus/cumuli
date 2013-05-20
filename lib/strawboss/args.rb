module Strawboss
  class Args
    attr_reader :argv

    def initialize(argv)
      @argv = argv
    end

    def dir
      @dir ||= argv.shift
    end

    def name
      @name ||= dir.match(/([a-z_]+)$/i)[0]
    end

    def foreman_options
      argv.join(' ')
    end
  end
end
