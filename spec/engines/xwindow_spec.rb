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

  def spawn_window(command)
    fake_window
  end

  def find_window(id)
    fake_window
  end

  def fake_window
    Windows::Structures::Window.new(1234, 'fake window', fake_desktop)
  end

  private

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
  let(:window)  { engine.fake_window }
  let(:id)      { window.id }

  it { should delegate(:title).to(:window) }
  it { should delegate(:desktop).to(:window) }
  it { should delegate(:x).to(:window) }
  it { should delegate(:y).to(:window) }
  it { should delegate(:width).to(:window) }
  it { should delegate(:height).to(:window) } 
  it { should respond_to :command= }

  it '#move' do
    args = [100, 200, 500, 400]

    subject.should_receive(:undock).ordered
    engine.should_receive(:action).with(id, :move_resize, 0, *args).ordered
    subject.move(*args)
  end

  context 'close' do
    it 'should delegate to engine' do
      engine.should_receive(:action).with(id, :close)
      subject.close
    end

    it 'should :id, :created_at set to false' do
      subject.create
      subject.close
      subject.id.should == false
      subject.created_at.should == false
    end
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

  context "#create" do
    before(:each) do
      Time.stub!(:now).and_return(time)
    end

    it 'should assign id' do
      subject.create
      subject.id.should == engine.fake_window.id 
    end

    it 'should assign created_at' do
      subject.create
      subject.created_at.should == time
    end

    it 'should return false when window is already created' do
      subject.create
      subject.create.should be_false
    end

    it 'should not spawn new window when it exist' do
      engine.should_receive(:find_window).with(command).and_return(window)
      engine.should_not_receive(:spawn_window).with(command)
      subject.create
    end
  end

  context '#window' do
    context "when window is not created" do
      it 'should create window' do
        subject.should_receive(:create)
        subject.window
      end
    end

    context "when window is created" do
      before do
        subject.create
      end

      it 'should delegate to engine' do
        engine.should_receive(:find_window).with(id)
        subject.window
      end
    end
  end

  it '#on_top' do
    engine.should_receive(:action).with(id, :change_state, "add", "above")
    subject.on_top
  end

  it '#not_on_top' do
    engine.should_receive(:action).with(id, :change_state, "remove", "above")
    subject.not_on_top
  end

  context "#action" do
    it 'should delegate to engine' do
      args = [0, 0, 0, 100, 200]

      engine.should_receive(:action).with(id, *args)
      subject.action(*args)
    end

    it 'should return self' do
      subject.action.should == subject
    end
  end

  it '#maximize' do
    engine.should_receive(:action).with(id, :change_state, "add", "maximized_vert", "maximized_horz")
    subject.maximize
  end
 
  context "initialize" do
    it "should use WMCtrl as default engine" do
      object = subject.class.new(command, options, nil)
      object.engine.should be_instance_of(Windows::Engines::WMCtrl)
    end
  end
end