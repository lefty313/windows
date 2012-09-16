require 'spec_helper'
require 'lazy/structures/collection'

class DummyStruct < Struct.new(:id)
end

describe Lazy::Structures::Collection do
  let(:klass) { Lazy::Structures::Collection }

  let(:collection_a) { klass.new [DummyStruct.new(1), DummyStruct.new(2)] }
  let(:collection_b) { klass.new collection_a.clone.push(DummyStruct.new(3)) }
  let(:collection_c) { klass.new collection_b.clone.push(DummyStruct.new(4)) }

  context "#-" do
    it 'bigger - smaller' do
      (collection_b - collection_a).should == collection_b[-1]
    end

    it 'smaller - bigger' do
      (collection_a - collection_b).should == nil
    end

    it 'bigger - smaller by more than one' do
      expect { collection_c - collection_a}.to raise_error "I don't know which item is correct [3, 4]"
    end
  end

end