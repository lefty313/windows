$LOAD_PATH.unshift File.expand_path(File.join(File.dirname(__FILE__),'../lib'))
require 'windows'

terminal1 = Windows::Window.new('x-www-browser')
terminal2 = Windows::Window.new('x-www-browser')
terminal3 = Windows::Window.new('x-www-browser')
windows   = [terminal1, terminal2, terminal3]

# first create all windows
windows.each(&:create)

# move with percentage values
terminal1.move '50%', '50%', '50%', '50%'

# move with special named argument
terminal2.move :top_right

# move with pixels
terminal3.move 0, 0, 300, 300

sleep 5
windows.each(&:close)
