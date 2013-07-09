module Cumuli
  def self.start(env='test')
    @app ||= App.new({
      env: env,
      log_dir: log_dir,
      app_dir: app_dir,
      wait_time: wait_time || App::DEFAULT_WAIT_TIME
    })
    @app.start
  end

  def self.stop
    @app.stop
  end

  class << self
    attr_accessor :env, :log_dir, :app_dir, :wait_time
  end
end
