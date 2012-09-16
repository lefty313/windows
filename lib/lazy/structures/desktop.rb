module Lazy
  module Structures
    class Desktop < Struct.new(:id, :geometry)
      def width
        geometry[0]
      end

      def height
        geometry[1]
      end
    end
  end
end