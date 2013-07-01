here = File.dirname(__FILE__)

require "#{here}/../lib/strawboss.rb"
Dir["#{here}/support/**/*.rb"].each {|f| require f}

require 'pty'

RSpec.configure do |config|
end
