require "windows/manager"

module Windows
  class Window
    include Manager

    attr_reader :command

    def initialize(command)
      @command = command
    end
  end
end