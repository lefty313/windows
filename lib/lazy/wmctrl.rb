require 'lazy/structures'

module Lazy

  class WMCtrl
    include Structures
    
    def action(*args)
      action_window(*args)
      pause
    end

    def register_window(&block)
      before = windows
      block.call
      
      # wait until windows list refresh
      after = loop do
        pause
        after = windows
        if after.ids != before.ids
          break after - before
        end
      end
    end

    def desktops
      list = list_desktops().map {|d| Desktop.new(d[:id], d[:geometry]) }
      Collection.new(list)
    end

    def windows
      list = list_windows(true).map do |w|
        desktop = find_desktop(w[:desktop])
        Window.new(w[:id], w[:title], desktop, *w[:geometry])
      end.sort_by(&:id)
      Collection.new(list)
    end

    def find_window(id)
      windows.find{ |w| w.id == id }
    end

    def find_desktop(id)
      desktops.find {|d| d.id == id}
    end
  
    private    

    def pause
      sleep 0.01
    end
  end
end