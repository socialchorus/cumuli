def preserving_env
  old_env = ENV.to_hash
  begin
    yield
  ensure
    ENV.clear
    ENV.update(old_env)
  end
end

def capture_stdout
  old_stdout = $stdout.dup
  rd, wr = IO.method(:pipe).arity.zero? ? IO.pipe : IO.pipe("BINARY")
  $stdout = wr
  yield
  wr.close
  rd.read
ensure
  $stdout = old_stdout
end
