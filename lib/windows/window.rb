require "windows/manager"

module Windows
  class Window
    include Manager

    attr_reader :command, :options

    def initialize(command, options = {})
      @command = command
      @options = options
    end
  end
end