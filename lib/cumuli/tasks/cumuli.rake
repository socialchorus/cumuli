namespace :cumuli do
  require_relative "../ps"

  desc "kill the processes showing up in the nimbus:ps task"
  task :kill do
    Cumuli::PS.new.kill
  end

  desc "look at processes likely related to cumuli"
  task :ps do
    puts Cumuli::PS.new.matching
  end
end
