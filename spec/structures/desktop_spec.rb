require 'spec_helper'
require 'windows/structures/desktop'

describe Windows::Structures::Desktop do
  subject { Windows::Structures::Desktop.new(id,geometry) }
  let(:id)       { 1 }
  let(:geometry) { [800,600] }

  its(:width)  { 800 }
  its(:height) { 600 }
end