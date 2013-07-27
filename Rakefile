require "bundler/gem_tasks"
require "#{File.dirname(__FILE__)}/lib/cumuli/tasks.rb"

require 'cucumber'
require 'cucumber/rake/task'
Cucumber::Rake::Task.new(:cucumber) do |t|
  t.cucumber_opts = "features --format pretty"
end

desc 'run rspec'
task :spec do
  system('rspec')
end

desc "run rspec and cucumber"
task :default => [:spec, :cucumber]
