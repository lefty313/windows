require "windows/manager"

module Windows
  class Window
    include Manager

    attr_reader :command

    def initialize(command, opts = {})
      @command = command
      @opts    = {}
    end
  end
end