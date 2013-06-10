module Strawboss
  class Assassin
    attr_reader :signal, :parent_pid

    def initialize(parent_pid, signal='TERM')
      @signal = signal
      @parent_pid = parent_pid
    end

    def pids
      @pids ||= gather_pids
    end

    def gather_pids(pid_list=[parent_pid], collected=[parent_pid])
      return collected if pid_list.empty?
      new_pids = children(pid_list)
      collected += new_pids
      gather_pids(new_pids, collected)
    end

    def children(pid_list)
      ps_pids.map do |child, parent|
        child.to_i if pid_list.include?(parent.to_i)
      end.compact
    end

    def ps_pids
      @ps_pids ||= ps_shell.lines.map(&:split).map{|arr| [arr[0].to_i, arr[1].to_i]}
    end

    def ps_shell
      `ps axo pid,ppid`
    end

    def kill
      pids.each { |pid| Process.kill(signal, pid) }
    end
  end
end

