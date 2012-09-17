require 'spec_helper'
require 'time'
require 'windows/manager/xwindow'

Windows = Windows
class Windows::WMCtrl; end
class DummyEngine;end
class DummyWindow < Struct.new(:id, :title);end


describe Windows::Manager::XWindow do
  subject { Windows::Manager::XWindow.new(engine,command)}
  let(:engine)  { DummyEngine.new }
  let(:window)  { DummyWindow.new(100, 'chromium') }
  let(:command) { 'ls' }
  let(:id)      { 10 }
  let(:pid)     { 1010 }
  let(:time)    { Time.parse("Sep 13 2011")}

  before :each do
    subject.instance_variable_set(:@id,id)
  end

  it '#move' do
    args = [0, 100, 200, 500, 400]

    subject.should_receive(:undock).ordered
    engine.should_receive(:action).with(id, :move_resize, *args).ordered
    subject.move(args)
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
    subject.title.should == window.title
  end

  context "initialize" do
    it "should use WMCtrl as default engine" do
      object = subject.class.new(nil,command)
      object.engine.should be_instance_of(Windows::WMCtrl)
    end
  end

  context "exceptions" do
    it '#create raise if already created' do
      message = "already created at #{time}"

      subject.stub(:created_at).and_return(time)
      expect {subject.create}.to raise_error(message)
    end
  end
end