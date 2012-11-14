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
    window1 = Object.new
    window2 = Object.new
    subject.stub(:windows).and_return([window1, window2])
    window1.should_receive(:close)
    window2.should_receive(:close)
    subject.close
  end

  context '#open_window' do
    before do
      @window = stub_window
    end

    it 'should create window' do
      @window.should_receive(:create)
      subject.open_window(command, args)
    end

    it 'with block should yield window' do
      @window.should_receive(:focus)

      subject.open_window(command, args) do |w|
        w.focus
      end
    end

    it 'should store created window' do
      subject.open_window(command, args)
      subject.windows.should include(@window)
    end
  end

  def stub_window
    window = double("Window").as_null_object
    Windows::Window.should_receive(:new).with(command, args).and_return(window)
    window
  end
end