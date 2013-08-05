module Cumuli
  module ProjectManager
    class Manager
      DEFAULT_PROJECT_PATH = Dir.pwd

      attr_accessor :config_path, :procfile_path

      def initialize(path=DEFAULT_PROJECT_PATH)
        @path = path
        @config_path = "#{path}/config/projects.yml"
        @procfile_path = "#{path}/Procfile"
      end

      def publish
        File.open(procfile_path, 'w') do |f|
          projects.each do |project|
            f.write project.to_procfile
          end
        end
      end

      def setup
        publish
        submodules_init
        system('git submodule init')
        system('git submodule update')
        system("git submodule foreach git pull")
        setup_projects
      end

      def submodules_init
        projects.each { |project| project.submodule_init }
      end

      def setup_projects
        projects.each { |project| project.setup }
      end

      def projects
        @projects ||= config.map{ |name, opts| Cumuli::ProjectManager::Project.new(name, opts) }
      end

      def project(name)
        projects.detect{|p| p.name == name}
      end

      def config
        @config ||= YAML.load( File.read(config_path) )
      end
    end
  end
end
