require 'forwardable'
require 'windows/engines/wmctrl'
require 'windows/units/unit_converter'
require 'windows/structures/lazy_actions'

module Windows
  module Engines
    class XWindow
      extend Forwardable

      def_delegators :window, :title, :x, :y, :width, :height, :desktop

      attr_reader :engine, :command, :id, :created_at, :lazy_actions

      def initialize(command, options = {}, engine = nil)
        @engine  = engine || WMCtrl.new
        @command = command
        @lazy_actions = Structures::LazyActions.new(self, options)
      end

      def move(*args)
        args = convert_units(args)

        undock
        engine.action(id, :move_resize, 0, *args)
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
        @created_at = Time.now
        lazy_actions.run
        self
      end

      def window
        engine.find_window(@id)
      end

      private

      def convert_units(args)
        converter = Units::UnitConverter.new(desktop, *args)
        converter.convert
      end

    end
  end
end