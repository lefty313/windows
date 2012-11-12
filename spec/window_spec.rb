require 'spec_helper'
require 'windows'

describe Windows::Window do
	subject { Windows::Window.new('chromium-browser') }

	it { should respond_to :id, :title, :desktop, :x, :y, :width, :height }
  it { should respond_to :move, :close, :focus, :undock, :create, :window, :on_top, :not_on_top}
end