require 'forwardable'
require 'windows/engines/wmctrl'
require 'windows/units/unit_converter'

module Windows
  module Engines
    class XWindow
      extend Forwardable

      def_delegators :window, :title, :x, :y, :width, :height, :desktop

      attr_reader :engine, :created_at, :id
      attr_accessor :command

      def initialize(command, options = {}, engine = nil)
        @engine  = engine || WMCtrl.new
        @command = command
      end

      def move(*args)
        args = convert_units(args)
        undock
        action(:move_resize, 0, *args)
      end

      def close
        action(:close)
        @id = false
        @created_at = false
      end

      def focus
        action(:activate)
      end

      def undock
        action(:change_state, "remove", "maximized_vert", "maximized_horz")
      end

      def create
        return false if created_at

        window = engine.find_window(command)
        window ||= engine.spawn_window(command)

        @id         = window.id
        @created_at = Time.now
        self
      end

      def window
        create
        engine.find_window(id)
      end

      def on_top
        action(:change_state, "add", "above")
      end

      def not_on_top
        action(:change_state, "remove", "above")
      end

      def action(*args)
        create
        engine.action(id, *args)
        self
      end

      def maximize
        action(:change_state, "add", "maximized_vert", "maximized_horz")
      end

      private

      def convert_units(args)
        converter = Units::UnitConverter.new(desktop, *args)
        converter.convert
      end
    end
  end
end