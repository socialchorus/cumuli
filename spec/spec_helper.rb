here = File.dirname(__FILE__)

require "#{here}/../lib/cumuli"
Dir["#{here}/support/**/*.rb"].each {|f| require f}

require 'pty'

RSpec.configure do |config|
end
