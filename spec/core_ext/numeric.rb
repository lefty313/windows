require 'spec_helper'
require 'lazy/core_ext/numeric'

describe Numeric do
  context "#percent" do
    it 'return correct value' do
      1000.percent(10).should == 100
    end

    it 'floor result' do
      999.percent(31.53).should == 314
    end
  end
end
