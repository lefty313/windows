require 'windows/units/converter'
require 'windows/units/recognizer'
require 'windows/structures'

module Windows
  module Units
    class UnitConverter
      include Units::Converter
      include Units::Recognizer
      include Structures

      NAMED_GEOMETRY = {
        left:         [0,  0,  '50%',  '100%'],
        right:        ['50%', 0,  '50%',  '100%'],
        bottom:       [0,  '50%', '100%', '50%'],
        top:          [0,  0,  '100%', '50%'], 
        max:          [0,  0,  '100%', '100%'],
        bottom_right: ['50%', '50%', '50%', '50%'],
        bottom_left:  [0, '50%', '50%', '50%'],
        top_right:    ['50%', 0, '50%', '50%'],
        top_left:     [0, 0, '50%', '50%']
      }

      def initialize(desktop, *args)
        @width    = desktop.width
        @height   = desktop.height
        @geometry = create_geometry(args)
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

      private

      def create_geometry(args)
        return Geometry.new(*args) if args.count > 1

        if args[0].respond_to?(:to_sym) && geometry_exist?(args[0])
          args = find_geometry(args[0].to_sym)
          return Geometry.new(*args)
        else
          raise "Geometry with name #{args[0]} not exist. You can use #{NAMED_GEOMETRY.keys}"
        end
      end

      def find_geometry(name)
        NAMED_GEOMETRY[name.to_sym]
      end

      def geometry_exist?(name)
        NAMED_GEOMETRY.keys.include?(name.to_sym)
      end
    end
  end
end