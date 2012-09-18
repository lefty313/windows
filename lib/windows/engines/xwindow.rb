require 'forwardable'

module Windows
  module Engines
    class XWindow
      extend Forwardable

      def_delegators :window, :title, :x, :y, :width, :height, :desktop

      attr_reader :engine, :command, :id, :created_at

      def initialize(command, engine = nil)
        @engine  = engine || WMCtrl.new
        @command = command
      end

      def move(args)
        undock
        engine.action(id, :move_resize, *args)
        # log("move")
      end

      def close
        engine.action(id, :close)
        log("close")
      end

      def focus
        engine.action(id, :activate)
        log("focus")
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
        @created_at = Time.now
        self
      end

      def window
        engine.find_window(@id)
      end

      private

        def log(status)
        # puts "[#{status} window] id: #{id} time: #{Time.now.strftime("%H:%M:%S")}"
      end

    end
  end
end