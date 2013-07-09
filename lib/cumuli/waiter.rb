module Cumuli
  class Waiter
    TIMEOUT = 30
    MESSAGE = "#wait_until did not resolve after #{TIMEOUT} seconds"

    attr_reader :message

    def initialize(message=MESSAGE)
      @message = message
    end

    def wait_until(timeout=TIMEOUT, &block)
      begin
        Timeout.timeout(timeout) do
          sleep(0.1) until value = block.call
          value
        end
      rescue Timeout::Error
        raise message
      end
    end
  end
end
