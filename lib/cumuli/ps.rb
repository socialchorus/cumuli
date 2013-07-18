module Cumuli
  class PS
    REGEX = /ruby|resque|foreman|rvm|node/

    attr_reader :lines

    def initialize(list=self.class.list)
      @lines = list.lines
      @lines.shift # to remove header line
    end

    def matching(regex = REGEX)
      @matching ||= lines
        .select{|l| l.match(regex)}
        .select{|l| !l.match(/^#{Process.pid} /) }
    end

    def kill
      pids.each do |pid|
        Process.kill("SIGINT", pid)
      end
    end

    def pids(regex = REGEX)
      matching(regex)
        .map(&:split)
        .map(&:first)
        .map(&:to_i)
    end

    def ppid_hash
      lines
        .map(&:split)
        .inject({}) do |hash, line_values|
          pid = line_values[0].to_i
          ppid = line_values[1].to_i
          hash[ppid] ||= []
          hash[ppid] << pid
          hash
        end
    end

    def line(pid)
      lines.detect{|l| l.match(/^#{pid} /)}
    end

    def tree(pid)
      collection = []
      if kids = children(pid)
        collection += kids
        kids.each do |k|
          collection += tree(k)
        end
      end
      collection
    end

    def children(pid)
      ppid_hash[pid]
    end

    def report(pid)
      tree(pid)
      puts "\n"
      puts matching
    end

    def self.list
      `ps axo pid,ppid,comm,args,user`
    end
  end
end
