require 'wmctrl'
require 'windows/structures'

class WMCtrl
  include Windows::Structures

  attr_reader :id
  
  def action(*args)
    raise "you must create window before using" unless id

    action_window(id, *args)
    pause
  end

  def create_window(command)
    register_window do
      pid = Process.spawn(command, :out => :close, :err => :close)
      Process.detach(pid)
    end
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
    list = list_desktops.map {|d| Desktop.new(d[:id], d[:workarea]) }
    Collection.new(list)
  end

  def windows
    list = list_windows(true).map do |w|
      # wmctrl mark default desktop as -1
      desktop_id = w[:desktop].abs
      desktop = find_desktop(desktop_id)
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
    sleep 0.05
  end
end