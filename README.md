windows
====

Ruby framework for manipulating Xwindow windows

### Installation for unix system
```bash  
  sudo apt-get install libx11-dev libglib2.0-dev libxmu-dev
```
``` ruby
  gem install windows
```

### Usage
```ruby
require 'windows'

p = Windows::Project.new(:default,'~')

p.open_window('chromium-browser').move(:left)
p.open_window('sublime-text-2 .').move(:right)
p.open_window('gnome-terminal').move(:bottom_right).on_top

sleep 5
p.close
```  
