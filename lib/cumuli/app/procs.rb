module Cumuli
  class App
    class Procs
      attr_reader :port_map, :path, :apps

      def initialize(path=nil)
        @path = (path || Dir.pwd) + "/Procfile"
        parse_procfile
      end

      def map
        @map ||= apps.inject({}) do |hash, app|
          hash[app.name] = app.port
          hash
        end
      end

      def file
        @file ||= File.read(path)
      end

      def parse_procfile
        @apps = file.lines.map do |line|
          SubApp.new(line)
        end
      end

      def names
        map.keys
      end

      class SubApp
        attr_reader :parts

        def initialize(line)
          @parts = line.split
        end

        def name
          parts.first.gsub(':', '')
        end

        def port
          if index = parts.find_index('-p')
            parts[index + 1] && parts[index + 1].to_i
          end
        end
      end
    end
  end
end
