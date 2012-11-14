$LOAD_PATH.unshift lib = File.expand_path(File.join(File.dirname(__FILE__),'../lib'))
require 'windows'

p = Windows::Project.new(:default,lib)

p.open_window('x-www-browser').move(:right)
p.open_window('x-terminal-emulator').move(:bottom)

sleep 5
p.close
