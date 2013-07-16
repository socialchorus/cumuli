require_relative "../ps"
require_relative "../cli/remote_command"
require_relative "../cli/commander"
require_relative "../cli/terminal"

namespace :cumuli do
  desc "kill the processes showing up in the nimbus:ps task"
  task :kill do
    Cumuli::PS.new.kill
  end

  desc "look at processes likely related to cumuli"
  task :ps do
    puts Cumuli::PS.new.matching
  end

  desc "run a remote command with the right ruby: rake cumuli:remote ../my_app rake db:migrate"
  task :remote do |command|
    Cumuli::CLI::RemoteCommand.new(ARGV).perform
  end
end
