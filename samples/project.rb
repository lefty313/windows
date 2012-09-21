$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "../lib/")))
require 'pry'
require 'windows'

p = Windows::Project.new(:default,'~')
p.editor  = 'subl ../'
p.browser = 'chromium-browser'

begin
  p.open_editor
  p.open_browser
  p.open_window 'gnome-terminal'
  p.create

  sleep 5
ensure
  p.close
end