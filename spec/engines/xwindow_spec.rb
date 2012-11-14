require 'spec_helper'
require 'time'
require 'windows/engines/xwindow'
require 'windows/structures/window'
require 'windows/structures/desktop'

module Windows
  module Engines
    class WMCtrl
    end
  end
end

class DummyEngine
  def action(*args)
  end

  def create_window(command)
  end

  def current_window
    fake_window
  end

  private

  def fake_window
    Windows::Structures::Window.new(1234, 'fake window', fake_desktop)
  end

  def fake_desktop
    Windows::Structures::Desktop.new(9876, [0,0,800,600])
  end
end
class DummyWindow < Struct.new(:id, :title);end
class DummyDesktop < Struct.new(:x_offset, :y_offset, :width, :height);end

describe Windows::Engines::XWindow do
  subject { Windows::Engines::XWindow.new(command, options, engine)}
  let(:engine)  { DummyEngine.new }
  let(:command) { 'ls' }
  let(:time)    { Time.parse("Sep 13 2011")}
  let(:options) { Hash.new }

  it { should delegate(:title).to(:window) }
  it { should delegate(:desktop).to(:window) }
  it { should delegate(:x).to(:window) }
  it { should delegate(:y).to(:window) }
  it { should delegate(:width).to(:window) }
  it { should delegate(:height).to(:window) }
  it { should delegate(:id).to(:window) }
  it { should delegate(:created_at).to(:window) }

  context "return value" do
    it '#create' do
      subject.create.should == subject
    end

    it '#move' do
      subject.move(:right).should == subject
    end

    it '#close' do
      subject.close.should == subject
    end

    it '#focus' do
      subject.focus.should == subject
    end

    it '#undock' do
      subject.undock.should == subject
    end

    it '#on_top' do
      subject.on_top.should == subject
    end

    it '#not_on_top' do
      subject.not_on_top.should == subject
    end
  end

  it '#move' do
    args = [100, 200, 500, 400]

    subject.should_receive(:undock).ordered
    engine.should_receive(:action).with(:move_resize, 0, *args).ordered
    subject.move(*args)
  end

  it '#close' do
    engine.should_receive(:action).with(:close)
    subject.close
  end

  it '#focus' do
    engine.should_receive(:action).with(:activate)
    subject.focus  
  end

  it '#undock' do
    args = ["remove", "maximized_vert", "maximized_horz"]

    engine.should_receive(:action).with(:change_state, *args)
    subject.undock
  end

  it '#create' do
    engine.should_receive(:create_window).with(command)
    subject.create
  end

  it '#window' do
    engine.should_receive(:current_window)
    subject.window
  end

  it '#on_top' do
    engine.should_receive(:action).with(:change_state, "add", "above")
    subject.on_top
  end

  it '#not_on_top' do
    engine.should_receive(:action).with(:change_state, "remove", "above")
    subject.not_on_top
  end
 
  context "initialize" do
    it "should use WMCtrl as default engine" do
      object = subject.class.new(command, options, nil)
      object.engine.should be_instance_of(Windows::Engines::WMCtrl)
    end
  end
end