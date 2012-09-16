module Lazy
  module Structures
    class Collection < SimpleDelegator
      def ids
        collect(&:id)
      end

      def -(collection)
        diff_id = ids - collection.ids
        return nil if diff_id.empty?

        raise "I don't know which item is correct #{diff_id}" if diff_id.count != 1
        find { |r| r.id == diff_id[0] }
      end
    end
  end
end 
