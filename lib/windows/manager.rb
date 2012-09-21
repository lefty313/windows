require 'forwardable'
require 'windows/engines/xwindow'

module Windows
  module Manager
    def self.included(base)
      base.extend Forwardable
      # window data delegators
      base.def_delegators :manager, :id, :title, :x, :y, :width, :height, :desktop
      # window actions
      base.def_delegators :manager, :move, :close, :focus, :undock, :create, :window
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