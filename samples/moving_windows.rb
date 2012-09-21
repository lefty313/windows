$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "../lib/")))
require 'pry'
require 'windows'

# class Window < Struct.new(:command)
#   include Windows::Manager
# end

terminal = Windows::Window.new('gnome-terminal')
editor   = Windows::Window.new('subl ../')

windows = []
windows << terminal
windows << editor

begin
  windows.each(&:create)
  editor.move(0,0, '100%', '100%')
  terminal.move('50%','50%', '50%','50%')
  sleep 5
ensure
  windows.each(&:close)
end