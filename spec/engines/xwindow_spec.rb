require 'spec_helper'
require 'time'
require 'windows/engines/xwindow'

module Windows
  module Engines
    class WMCtrl
    end
  end
end

class DummyEngine
  def find_window(id)
  end
end
class DummyWindow < Struct.new(:id, :title);end
class DummyDesktop < Struct.new(:width, :height);end

describe Windows::Engines::XWindow do
  subject { Windows::Engines::XWindow.new(command, engine)}
  let(:engine)  { DummyEngine.new }
  let(:window)  { DummyWindow.new(100, 'chromium') }
  let(:command) { 'ls' }
  let(:id)      { window.id }
  let(:pid)     { 1010 }
  let(:time)    { Time.parse("Sep 13 2011")}

  before :each do
    subject.instance_variable_set(:@id,id)
  end

  it { should delegate(:title).to(:window) }
  it { should delegate(:desktop).to(:window) }
  it { should delegate(:x).to(:window) }
  it { should delegate(:y).to(:window) }
  it { should delegate(:width).to(:window) }
  it { should delegate(:height).to(:window) }

  it '#move' do
    args = [100, 200, 500, 400]
    create_desktop

    subject.should_receive(:undock).ordered
    engine.should_receive(:action).with(id, :move_resize, 0, *args).ordered
    subject.move(*args)
  end

  it '#close' do
    engine.should_receive(:action).with(id, :close)
    subject.close
  end

  it '#focus' do
    engine.should_receive(:action).with(id, :activate)
    subject.focus  
  end

  it '#undock' do
    args = ["remove", "maximized_vert", "maximized_horz"]

    engine.should_receive(:action).with(id, :change_state, *args)
    subject.undock
  end

  it "#create" do
    Time.any_instance.stub(:now).and_return(time)
    engine.stub(:register_window).and_return(window)
    engine.should_receive(:register_window).and_yield

    Process.should_receive(:spawn).with(command, out: :close, err: :close).and_return(pid)
    Process.should_receive(:detach).with(pid)

    subject.create.should == subject
    subject.id.should == window.id
  end

  it '#window' do
    engine.should_receive(:find_window).with(window.id)
    subject.window
  end
 
  context "initialize" do
    it "should use WMCtrl as default engine" do
      object = subject.class.new(command, nil)
      object.engine.should be_instance_of(Windows::Engines::WMCtrl)
    end
  end

  context "exceptions" do
    it '#create raise if already created' do
      message = "already created at #{time}"

      subject.stub(:created_at).and_return(time)
      expect {subject.create}.to raise_error(message)
    end
  end

  def create_desktop
    obj = DummyDesktop.new(800,600)
    subject.stub(:desktop).and_return(obj)
    obj
  end

end