require 'spec_helper'
require 'windows/units/unit_converter'

describe Windows::Units::Converter::Finder do
  let(:el)                { 1000 }
  let(:supported_formats) { [:percent, :pixel] }  
  subject                 { Windows::Units::Converter::Finder.new(el) }

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

describe Windows::Units::UnitConverter do
  let(:desktop) { Struct.new(:width, :height).new(800,600) }
  subject       { Windows::Units::UnitConverter.new(desktop, *args) }

  it 'NAMED_GEOMETRY' do
    expected_values = {
        left:         [0,  0,  '50%',  '100%'],
        right:        ['50%', 0,  '50%',  '100%'],
        bottom:       [0,  '50%', '100%', '50%'],
        top:          [0,  0,  '100%', '50%'], 
        max:          [0,  0,  '100%', '100%'],
        bottom_right: ['50%', '50%', '50%', '50%'],
        bottom_left:  [0, '50%', '50%', '50%'],
        top_right:    ['50%', 0, '50%', '50%'],
        top_left:     [0, 0, '50%', '50%']
      }
    Windows::Units::UnitConverter::NAMED_GEOMETRY.should == expected_values
  end

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

    context "named units" do
      let(:args) { 'left' }
      it 'left' do
        subject.convert.should == [0, 0, 400, 600]
      end

      it 'wrong name' do
        expect{ subject.class.new(desktop, 'wrong_name') }.to raise_error /Geometry with name wrong_name not exist. You can use/
      end
    end

  end
end

