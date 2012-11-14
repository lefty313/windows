require 'pathname'
require 'windows'

module Windows
  class Project
    attr_reader :root, :name, :windows

    def initialize(name, path)
      @windows = Array.new
      @root    = Pathname.new(path)
      @name    = name
    end

    def close
      @windows.each(&:close)
    end

    def create_window(klass, command, opts)
      window = klass.new(command, opts)
      yield window if block_given?
      @windows.push window
      window
    end

    def open_window(command, opts = {}, &block)
      create_window(Window, command, opts, &block)
    end

  end
end

