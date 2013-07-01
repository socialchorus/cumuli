require "bundler/gem_tasks"

desc "kill the ruby stuff, debugging script"
task :kill_rubies do
  ps_list = `ps axo pid,comm | grep ruby`
  pids = ps_list.lines.map(&:split).map(&:first).map(&:to_i) - [Process.pid]
  pids.each do |pid|
    Process.kill("SIGINT", pid)
  end
end

task :ps do
  ps = `ps axo pid,ppid,comm,args,user`
  puts ps.lines.select{|l| l.match(/ruby|resque|foreman|rvm/)}
end
