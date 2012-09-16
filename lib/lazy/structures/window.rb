module Lazy
  module Structures
    class Window < Struct.new(:id, :title, :desktop, :g, :x, :y, :width, :height)
    end
  end
end