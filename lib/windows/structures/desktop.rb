module Windows
  module Structures
    class Desktop < Struct.new(:id, :geometry)
      def width
        geometry[2]
      end

      def height
        geometry[3]
      end
    end
  end
end