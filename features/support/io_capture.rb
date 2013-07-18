def capturing(stream=:stdout)
  stream = $stdout
  old_stream = stream.dup
  new_steam = StringIO.new
  stream = new_steam
  yield
  new_steam
ensure
  stream = old_stream
  new_steam
end
