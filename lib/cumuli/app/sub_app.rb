module Cumuli
  class App
    class SubApp
      attr_reader :parts
      attr_accessor :host

      def initialize(line)
        @parts = line.split
        @host = 'localhost'
      end

      def name
        parts.first.gsub(':', '')
      end

      def port
        if index = parts.find_index('-p')
          parts[index + 1] && parts[index + 1].to_i
        end
      end

      def waitable?
        host != 'localhost' || port
      end

      def wait(timeout)
        return unless waitable?
        Waiter.new("Application on port #{port} unavailable after #{timeout} seconds")
          .wait_until(120) { socket_available? }
      end

      def url
        "http://#{host}#{port ? ':' + port.to_s : ''}"
      end

      def socket_available?
        TCPSocket.new(host, port)
        true
      rescue Errno::ECONNREFUSED
        false
      end
    end
  end
end
