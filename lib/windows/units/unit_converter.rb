require 'windows/units/converter'
require 'windows/units/recognizer'

module Windows
  module Units
    class Geometry < Struct.new(:x, :y, :w, :h)
      def inspect
        [g, x, y, w, h]
      end
    end

    class UnitConverter
      include Units::Converter
      include Units::Recognizer

      def initialize(desktop, *args)
        @width    = desktop.width
        @height   = desktop.height
        @geometry = Geometry.new(*args)
        @x_axis   = [@geometry.x, @geometry.w]
        @y_axis   = [@geometry.y, @geometry.h]
      end

      def convert
        x, w = @x_axis.map do |el|
          item = recognize_unit(el)
          converter(item.unit).to(item.format, base: @width)
        end

        y, h = @y_axis.map do |el|
          item = recognize_unit(el)
          converter(item.unit).to(item.format, base: @height)
        end

        [x, y, w, h]
      end
    end
  end
end