module Cumuli
  class PS
    REGEX = /ruby|resque|foreman|rvm|node/

    attr_reader :lines

    def initialize(list=self.class.list)
      lines = list.lines
      lines.shift # to remove the header
      @lines = lines.map{|l| Line.new(l) }
    end

    class Line
      attr_reader :pid, :ppid, :command

      def initialize(line)
        elements = line.split
        @pid = elements.shift.to_i
        @ppid = elements.shift.to_i
        @command = elements.join(' ')
      end

      def <=>(other)
        self.pid <=> other.pid
      end

      def to_s
        "#{pid} #{ppid} #{command}"
      end
    end

    def root_pid
      root && root.pid
    end

    def root
      foremans.first
    end

    def foremans
      lines.select{|l| l.command.match(/foreman: master/) }.sort
    end

    def int(pids=[root_pids])
      pids.compact.each do |pid|
        Process.kill('INT', pid)
      end
    end

    def kill(pids=[root_pid])
      pids.compact.each do |pid|
        Process.kill(9, pid)
      end
    end

    def ppid_hash
      lines
        .inject({}) do |hash, line|
          hash[line.ppid] ||= []
          hash[line.ppid] << line.pid
          hash
        end
    end

    def line(pid=root_pid)
      line = lines.detect{|l| l.pid == pid }
      line && line.to_s
    end

    def family(pid=root_pid)
      collection = []
      if kids = children(pid)
        collection += kids
        kids.each do |k|
          collection += family(k)
        end
      end
      collection
    end

    def children(pid=root_pid)
      ppid_hash[pid]
    end

    def report(pid=root_pid)
      r = [line(pid).to_s]
      family(pid).each do |p|
        l = line(p)
        r << l.to_s
      end
      r.join("\n")
    end

    def report_all
      r = []
      foremans.each do |line|
        r << report(line.pid)
      end
      r.join("\n")
    end

    def self.list
      `ps axo pid,ppid,comm,args,user`
    end
  end
end
