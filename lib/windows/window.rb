module Windows
  class Window
    attr_reader :command, :options

    def initialize(command, options = {})
      @command = command
      @options = options
    end
  end
end