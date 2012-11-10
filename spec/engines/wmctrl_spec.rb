require 'spec_helper'
require 'windows/engines/wmctrl'

describe WMCtrl do
  before :each do
    create_windows
    create_desktops
  end

  it '#create_window' do
    window = Struct.new(:id).new(1500)
    subject.stub(:register_window).and_return(window)

    created_window = subject.create_window('any_command')
    created_window.id == window.id
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

  it "#find_windows" do
    window = subject.find_window(2)
    window.id.should == 2
    window.should be_instance_of Windows::Structures::Window
  end

  it "#action" do
    args = [0, :move_resize, 0, 100, 200, 500, 400]

    subject.should_receive(:action_window).with(*args)
    subject.should_receive(:pause)
    subject.action(*args)
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
    @windows.push({id: 2, title: 'list', desktop: 1, geometry: [50,50,200,400]})
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