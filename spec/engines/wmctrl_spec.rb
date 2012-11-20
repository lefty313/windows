require 'spec_helper'
require 'windows/engines/wmctrl'
require 'time'

describe WMCtrl do
  let(:fake_window_id) { 1234 }
  let(:window)         { Windows::Structures::Window.new(fake_window_id) }
  let(:time)           { Time.parse("Sep 13 2011") }
  let(:command)        { 'any_command' }

  before :each do
    create_windows
    create_desktops
  end

  context "spawn_window" do
    it 'should raise exception when command not exist' do
      Process.stub(:spawn).and_raise(Errno::ENOENT)
      expect { subject.spawn_window(command) }.to raise_error "Failed to create window with command: #{command}. Maybe a typo?"
    end
  end

  it "#desktops" do
    list = subject.desktops
    desktops.zip(list).each do |desktop, desktop_window|
      desktop[:id].should       == desktop_window.id   
      desktop[:workarea].should == desktop_window.geometry         
    end

    list.should be_instance_of(Windows::Structures::Collection)
  end

  it "#find_desktops" do
    desktop = subject.find_desktop(1)
    desktop.id.should == 1
    desktop.should be_instance_of(Windows::Structures::Desktop)
  end

  context "#windows" do
    it 'return windows' do
      list = subject.windows

      windows(:sorted).zip(list).each do |stub, window|
        desktop = subject.find_desktop(stub[:desktop])

        stub[:id].should          == window.id
        stub[:title].should       == window.title
        stub[:desktop].should     == desktop.id
        stub[:geometry][0].should == window.x
        stub[:geometry][1].should == window.y
        stub[:geometry][2].should == window.width
        stub[:geometry][3].should == window.height
      end

      list.should be_instance_of(Windows::Structures::Collection)
    end

    it 'return sorted by :id' do
      expected_ids = windows(:sorted).map {|w| w[:id]}

      subject.windows.ids.should == expected_ids
    end
  end

  context "#find_windows" do
    it 'should find window by id' do
      subject.find_window(2).id.should == 2
    end

    it 'should return Window' do
      subject.find_window(2).should be_instance_of Windows::Structures::Window
    end
  end

  it '#active_window' do
    subject.active_window.active.should be_true
  end

  private

  def desktops
    unless @desktops
      klass = Windows::Structures::Desktop
      @desktops = []
      @desktops.push({id: 1, workarea: [0, 0, 800, 600]})
      @desktops.push({id: 2, workarea: [0, 0, 1200, 1000]})
    end
    @desktops
  end

  def windows(sorted = false)
    unless @windows
    klass = Windows::Structures::Window
    @windows = []
    @windows.push({id: 1, title: 'bash', desktop: 1, geometry: [0,0,100,200]})
    @windows.push({id: 3, title: 'torr', desktop: 2, geometry: [100,100,400,800]})
    @windows.push({id: 2, title: 'list', desktop: 1, geometry: [50,50,200,400], active: true})
    end
    sorted ? @windows.sort_by{|w| w[:id]} : @windows 
  end

  def create_windows
    subject.stub(:list_windows).and_return(windows)
  end

  def create_desktops
    subject.stub(:list_desktops).and_return(desktops)
  end

end