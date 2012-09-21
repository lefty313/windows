require 'spec_helper'
require 'windows/manager'

class DummyObject
  include Windows::Manager

  def options
    Hash.new
  end
end

describe Windows::Manager do
  subject { object }
  let(:object) { DummyObject.new }

  it { should respond_to :manager }
  it { should respond_to :id, :title, :desktop, :x, :y, :width, :height }
  it { should respond_to :move, :close, :focus, :undock, :create, :window }

  it '#manager' do
    subject.stub(:command).and_return('gnome-terminal')
    subject.manager.should be_instance_of Windows::Engines::XWindow
  end

end