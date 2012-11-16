require 'forwardable'
require 'windows/engines/wmctrl'
require 'windows/units/unit_converter'

module Windows
  module Engines
    class XWindow
      extend Forwardable

      def_delegators :window, :title, :x, :y, :width, :height, :desktop

      attr_reader :engine, :command, :created_at, :id

      def initialize(command, options = {}, engine = nil)
        @engine  = engine || WMCtrl.new
        @command = command
      end

      def move(*args)
        args = convert_units(args)
        undock
        action(:move_resize, 0, *args)
        self
      end

      def close
        action(:close)
        self
      end

      def focus
        action(:activate)
        self
      end

      def undock
        action(:change_state, "remove", "maximized_vert", "maximized_horz")
        self
      end

      def create
        raise "already created at #{created_at}" if created_at

        window = engine.spawn_window(command)

        @id         = window.id
        @created_at = Time.now
        self
      end

      def window
        engine.current_window
      end

      def on_top
        action(:change_state, "add", "above")
        self
      end

      def not_on_top
        action(:change_state, "remove", "above")
        self
      end

      def action(*args)
        create
        engine.action(id, *args)
      end

      private

      def convert_units(args)
        converter = Units::UnitConverter.new(desktop, *args)
        converter.convert
      end
    end
  end
end