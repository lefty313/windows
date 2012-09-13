module Lazy
  module Manager
    class XWindow
      attr_reader :engine, :command, :id, :title, :created_at

      def initialize(engine = nil, command)
        @engine  = engine || WMCtrl.new
        @command = command
      end

      def move(args)
        undock
        engine.action(id, :move_resize, *args)
      end

      def close
        engine.action(id, :close)
      end

      def focus
        engine.action(id, :activate)
      end

      def undock
        engine.action(id, :change_state, "remove", "maximized_vert", "maximized_horz")
      end

      def create
        raise "already created at #{created_at}" if created_at

        window = engine.register_window do
          pid = Process.spawn(command, :out => :close, :err => :close)
          Process.detach(pid)
        end
        @id         = window.id
        @title      = window.title
        @created_at = Time.now
        self
      end
    end
  end
end