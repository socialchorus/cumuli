require 'cucumber'

require_relative "../../lib/cumuli"

Dir["#{File.dirname(__FILE__)}/*.rb"].each do |f|
  require f
end


at_exit do
  #@app.stop
end

