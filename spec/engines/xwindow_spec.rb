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

  def create_window(command)
  end
end
class DummyWindow < Struct.new(:id, :title);end
class DummyDesktop < Struct.new(:x_offset, :y_offset, :width, :height);end

describe Windows::Engines::XWindow do
  subject { Windows::Engines::XWindow.new(command, options, engine)}
  let(:engine)  { DummyEngine.new }
  let(:window)  { DummyWindow.new(100, 'chromium') }
  let(:command) { 'ls' }
  let(:id)      { window.id }
  let(:pid)     { 1010 }
  let(:time)    { Time.parse("Sep 13 2011")}
  let(:options) { Hash.new }

  before :each do
    stub_window_id(id)
  end

  it { should delegate(:title).to(:window) }
  it { should delegate(:desktop).to(:window) }
  it { should delegate(:x).to(:window) }
  it { should delegate(:y).to(:window) }
  it { should delegate(:width).to(:window) }
  it { should delegate(:height).to(:window) }
  its(:lazy_actions) { should be_instance_of Windows::Structures::LazyActions }

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

  context "#create" do
    before(:each) do
      stub_time(time)
      stub_window(window)
      remove_window_id
    end

    it 'should assign id' do
      subject.create
      subject.id.should == window.id 
    end

    it 'should assign created_at' do
      subject.create
      subject.created_at.should == time
    end

    it 'should raise exception when window is already created' do
      subject.create
      expect { subject.create }.to raise_error "already created at #{time}"
    end
  end

  it '#window' do
    engine.should_receive(:find_window).with(window.id)
    subject.window
  end

  it '#on_top' do
    engine.should_receive(:action).with(id, :change_state, "add", "above")
    subject.on_top
  end

  it '#not_on_top' do
    engine.should_receive(:action).with(id, :change_state, "remove", "above")
    subject.not_on_top
  end
 
  context "initialize" do
    it "should use WMCtrl as default engine" do
      object = subject.class.new(command, options, nil)
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
    obj = DummyDesktop.new(0, 0, 800,600)
    subject.stub(:desktop).and_return(obj)
    obj
  end

  def stub_window(window)
    engine.stub(:create_window).and_return(window)
  end

  def stub_window_id(id)
    subject.instance_variable_set(:@id,id)
  end

  def stub_time(time)
    Time.stub!(:now).and_return(time)
  end

  def remove_window_id
    stub_window_id(nil)
  end

end