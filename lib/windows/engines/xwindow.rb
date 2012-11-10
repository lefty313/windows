require 'forwardable'
require 'windows/engines/wmctrl'
require 'windows/units/unit_converter'

module Windows
  module Engines
    class XWindow
      extend Forwardable

      def_delegators :window, :title, :x, :y, :width, :height, :desktop

      attr_reader :engine, :command, :id, :created_at

      def self.window_methods
        public_instance_methods(false)
      end

      def initialize(command, options = {}, engine = nil)
        @engine  = engine || WMCtrl.new
        @command = command
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
        engine.create_window(command)
      end

      def window
        engine.find_window(@id)
      end

      def on_top
        engine.action(id, :change_state, "add", "above")
      end

      def not_on_top
        engine.action(id, :change_state, "remove", "above")
      end

      private

      def convert_units(args)
        converter = Units::UnitConverter.new(desktop, *args)
        converter.convert
      end

    end
  end
end