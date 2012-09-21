require 'windows/window'
require 'pathname'

module Windows
  class Project
    attr_accessor :editor, :browser
    attr_reader   :root, :name, :windows

    def initialize(name, path)
      @windows = Array.new
      @root    = Pathname.new(path)
      @name    = name
    end

    def create
      @windows.each(&:create)
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

    def open_editor(opts = {}, &block)
      open_window(editor, opts, &block)
    end

    def open_browser(opts = {}, &block)
      open_window(browser, opts, &block)
    end

  end
end

