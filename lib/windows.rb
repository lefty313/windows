require "windows/version"
require "windows/project"
require "windows/engines/xwindow"

module Windows
  Window = Engines::XWindow
  ActiveWindowKey = :active
end

