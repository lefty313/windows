$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "../lib/")))
require 'pry'
require 'windows'

p = Windows::Project.new(:default,'~')
p.editor  = 'subl ../'
p.browser = 'chromium-browser'

begin
  p.open_editor do |editor|
    editor.move :left
  end

  p.open_browser do |browser|
    browser.move :right
  end
  
  p.open_window 'gnome-terminal', move: 'bottom_right' do |terminal|
    terminal.on_top
  end

  p.create
  sleep 5
ensure
  p.close
end