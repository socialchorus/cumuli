module Cumuli
  class Terminal
    VARS = ['GEM_HOME', 'GEM_PATH', 'RUBYOPT', 'RBENV_DIR']

    attr_reader :command

    def initialize(command)
      @command = command
    end

    def bundled?
      Object.const_defined?('Bundler')
    end

    def spawn
      bundled? ? call_bundled : execute_command
    end

    def call_bundled
      Bundler.with_clean_env do
        clear_env
        execute_command
      end
    end

    def execute_command
      exec(command)
    end

    def clear_env
      VARS.each { |e| ENV.delete(e) }
    end
  end
end

