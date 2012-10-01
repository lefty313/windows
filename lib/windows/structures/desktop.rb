module Windows
  module Structures
    class Desktop < Struct.new(:id, :geometry)
      def width
        geometry[2]
      end

      def height
        geometry[3]
      end

      def x_offset
        geometry[0]
      end

      def y_offset
        geometry[1]
      end
    end
  end
end