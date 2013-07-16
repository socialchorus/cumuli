module Cumuli
  class App
    class StdoutLogger
      GRAY = "\033[0;37m"
      RESET = "\033[0m"

      def print(message)
        puts "Cumuli: #{GRAY}#{message}#{RESET}"
      end

      def add_space
        puts ''
      end
    end
  end
end
