require 'spec_helper'
require 'lazy/units/unit_converter'

describe Lazy::Units::Converter::Finder do
  let(:el)                { 1000 }
  let(:supported_formats) { [:percent, :pixel] }  
  subject                 { Lazy::Units::Converter::Finder.new(el) }

  it '#to(:percent, base)' do
    format = :percent
    subject.to(format, base: 25).should == 250
  end

  it '#to(:pixel)' do
    format = :pixel
    subject.to(format).should == 1000
  end

  it '#to(:nil || false)' do
    format = nil
    expect { subject.to(format) }.to raise_error "I only support this formats #{supported_formats}"
  end

end

describe Lazy::Units::UnitConverter do
  let(:desktop) { Struct.new(:width, :height).new(800,600) }
  subject       { Lazy::Units::UnitConverter.new(desktop, *args) }

  describe "#convert" do
    context "pixels" do
      let(:args) { [0, 0, 50, 100] }

      it 'should work' do
        subject.convert.should == [0, 0, 50, 100]
      end
    end

    context "percents" do
      let(:args) { ['0%','0%','50%','100%'] }
      it 'should work' do
        subject.convert.should == [0, 0 , 400, 600]
      end
    end

    context "mixed units" do
      let(:args) { ['50%', 0, '100%', 25] }
      it 'should work' do
        subject.convert.should == [400, 0, 800, 25]
      end
    end  
  end
end

