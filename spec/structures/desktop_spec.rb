require 'spec_helper'
require 'windows/structures/desktop'

describe Windows::Structures::Desktop do
  subject { Windows::Structures::Desktop.new(id,geometry) }
  let(:id)       { 1 }
  let(:geometry) { [10, 20, 800,600] }

  its(:width)    { should == 800 }
  its(:height)   { should == 600 }
  its(:x_offset) { should == 10 }
  its(:y_offset) { should == 20 }
end