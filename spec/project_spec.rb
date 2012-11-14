require 'spec_helper'
require 'windows/project'

describe Windows::Project do
  subject      { Windows::Project.new(name, path) }
  let(:name)   { :my_project }
  let(:path)   { 'path/to/project' }
  let(:editor) { 'bin/my_editor' }
  let(:browser){ 'bin/my_browser' }
  let(:args)   { {foo: 'bar', hello: 'world'} }
  let(:command){ 'any_command' }

  context "options" do
    it 'return root as pathname' do
      subject.root.should == Pathname.new(path)
    end

    it 'return name' do
      subject.name.should == name
    end
  end

  it '#close' do
    create_windows

    subject.windows.each do |w|
      w.should_receive(:close)
    end
    subject.close
  end


  context "#create_window" do
    it 'should return Windows::Window' do
      value = subject.create_window(Windows::Window, command, args)
      value.should be_instance_of Windows::Window
    end

    it 'with block should yield window' do
      window = double("Windows::Window")
      window.should_receive(:new_tab)
      Windows::Window.should_receive(:new).with(command, args).and_return(window)

      subject.create_window Windows::Window, command, args do |window|
        window.new_tab 
      end
    end

    it 'should store created windows' do
      windows = create_windows

      subject.windows.should == windows
    end
  end

  context '#open_window' do
    it 'should pass arguments to :create_window' do
      subject.should_receive(:create_window).with(Windows::Window, command, args)
      subject.open_window command, args
    end
  end

  context '#open_editor' do
    before :each do
      subject.editor = editor
    end

    it 'should use #editor as command' do
      subject.should_receive(:open_window).with(editor, args)
      subject.open_editor args
    end
  end

  context '#open_browser' do
    before :each do
      subject.browser = browser
    end

    it 'should use #browser as command' do
      subject.should_receive(:open_window).with(browser, args)
      subject.open_browser args
    end
  end  

  def create_windows
    unless @stubbed_windows
      window1 = subject.create_window Windows::Window, command , args
      window2 = subject.create_window Windows::Window, command , args
    end
    @stubed_windows ||= [window1, window2]
  end

end