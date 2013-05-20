require 'pty'

module Strawboss
  class Terminal
    VARS = ['GEM_HOME', 'GEM_PATH', 'RUBYOPT', 'RBENV_DIR']

    attr_reader :command, :block

    def initialize(command, &block)
      @command = command
      @block = block
    end

    def bundled?
      Object.const_defined?('Bundler')
    end

    def spawn
      bundled? ? call_bundled : call_normal
    end

    def call_bundled
      Bundler.with_clean_env do
        clear_env
        call_normal
      end
    end

    def call_normal
      PTY.spawn(command) do |read, write, pid|
        begin
          block.call(read, write, pid)
        rescue Errno::EIO
        ensure
          Process.wait pid
        end
      end

      $?.exitstatus
    end

    def clear_env
      VARS.each { |e| ENV.delete(e) }
    end
  end
end

