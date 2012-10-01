$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__),'../lib'))
require 'windows'

terminal = Windows::Window.new('gnome-terminal', move: ['50%','50%', '50%','50%'])
editor   = Windows::Window.new('subl ../', move: [0,0, '100%', '100%'])

windows = []
windows << terminal
windows << editor

begin
  windows.each(&:create)
  # editor.move('0%','0%', '98%', '100%')
  # terminal.move('50%','50%', '50%','50%')
  sleep 5
ensure
  windows.each(&:close)
end