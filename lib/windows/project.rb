require 'pathname'
require 'windows'

module Windows
  class Project
    attr_reader :root, :name, :windows

    def initialize(name, path)
      @windows = Array.new
      @root    = Pathname.new(path).expand_path
      @name    = name
    end

    def close
      windows.each(&:close)
    end

    def open_window(command, opts = {}, &block)
      window = Windows::Window.new(command, opts).create
      yield window if block_given?
      windows.push(window)
      window
    end

  end
end

