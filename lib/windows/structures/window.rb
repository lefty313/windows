module Windows
  module Structures
    class Window < Struct.new(:id, :title, :desktop, :x, :y, :width, :height, :active)
    end
  end
end