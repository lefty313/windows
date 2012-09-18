require 'pry'
require 'windows'

class MyWindow
  include Windows::Manager

  def command
    'gnome-terminal'
  end
end

w = MyWindow.new
binding.pry