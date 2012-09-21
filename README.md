windows
====

Ruby framework for manipulating Xwindow manager windows

### Installation for unix system
```bash  
  sudo apt-get install libx11-dev libglib2.0-dev libxmu-dev
```
``` ruby
  gem install windows
```

### OOP Usage
```ruby
  p = Windows::Project.new(:default,'~')
  p.editor  = 'subl ../'
  p.browser = 'chromium-browser'

  # with block
  p.open_editor do |editor|
    editor.move :left
  end

  # with block and default action
  p.open_window 'gnome-terminal', move: 'bottom_right' do |terminal|
    terminal.on_top
  end

  # this method create windows associated with project
  p.create
  sleep 5
  # this method close all windows associated with project
  p.close

```  
