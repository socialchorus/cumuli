require_relative "../../cumuli"

namespace :cumuli do
  namespace :project do
    desc "install submodules and run setup scripts based on the project.yml"
    task :setup do
      Cumuli::ProjectManager::Manager.new.setup
    end

    desc "copy database config and rerun setup scripts"
    task :config do
      Cumuli::ProjectManager::Manager.new.setup_projects
    end
  end

  namespace :ps do
    namespace :kill do
      desc "kill all foreman related processes"
      task :all do
        ps = Cumuli::PS.new
        ps.kill(ps.foremans.map(&:pid))
      end

      desc "kill the first spawned foreman process"
      task :root do
        ps = Cumuli::PS.new
        ps.kill
      end
    end

    desc "kill the root process"
    task :kill => ['cumuli:kill:root']

    namespace :int do
      desc "interrupt all foreman related processes"
      task :all do
        ps = Cumuli::PS.new
        ps.int(ps.foremans.map(&:pid))
      end

      desc "kill the first spawned foreman process"
      task :root do
        ps = Cumuli::PS.new
        ps.int
      end
    end

    desc "interrupt the root process"
    task :int => ['cumuli:int:root']
  end

  desc "look at the list of foreman related processes"
  task :ps do
    puts Cumuli::PS.new.report_all
  end

  desc "run a remote command with the right ruby: rake cumuli:remote ../my_app rake db:migrate"
  task :remote do |command|
    Cumuli::CLI::RemoteCommand.new(ARGV).perform
  end
end
