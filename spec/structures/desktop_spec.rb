require 'spec_helper'
require 'lazy/structures/desktop'

describe Lazy::Structures::Desktop do
  subject { Lazy::Structures::Desktop.new(id,geometry) }
  let(:id)       { 1 }
  let(:geometry) { [800,600] }

  its(:width)  { 800 }
  its(:height) { 600 }
end