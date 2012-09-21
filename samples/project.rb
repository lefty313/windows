$:.unshift(File.expand_path(File.join(File.dirname(__FILE__), "../lib/")))
require 'pry'
require 'windows'

p = Windows::Project.new(:default,'~')
p.editor  = 'subl ../'
p.browser = 'chromium-browser'

begin
  p.open_editor do |editor|
    editor.move 0,0,'50%','100%'
  end

  p.open_browser do |browser|
    browser.move '50%',0,'50%','100%'
  end
  
  p.open_window 'gnome-terminal' do |terminal|
    terminal.on_top
    terminal.not_on_top
  end

  p.create
  sleep 5
ensure
  p.close
end