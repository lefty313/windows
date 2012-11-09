require 'forwardable'
require 'windows/engines/xwindow'

module Windows
  module Manager
    def self.included(base)
      base.extend Forwardable
      base.def_delegators :manager, *Engines::XWindow.window_methods
    end 

    def manager
      @manager ||= Engines::XWindow.new(command, options)
    end

    def options
      raise "you should implement this"
    end
 
    def command
      raise "you should implement this"
    end
  end
end