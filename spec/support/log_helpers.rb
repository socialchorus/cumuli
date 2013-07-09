def log_dir
  File.dirname(__FILE__) + "/../fixtures/log"
end

def clear_logs
  FileUtils.rm_rf(log_dir) if File.exist?(log_dir)
end
