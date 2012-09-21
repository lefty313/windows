require 'spec_helper'
require 'windows/structures/lazy_actions'

describe Windows::Structures::LazyActions do
  subject       { Windows::Structures::LazyActions.new(engine, actions) }
  let(:engine)  { Object.new }
  let(:actions) { {move: [0,0,0,0], bar: 'foo', undock: true } }

  its(:allowed_actions) { should == [:move, :undock, :focus]}
  its(:actions_to_run)   { should == [ [:move, [0,0,0,0]], [:undock, true] ] }

  it '#run' do
    engine.should_receive(:move).with(0,0,0,0).ordered
    engine.should_receive(:undock).with(no_args).ordered
    subject.run
  end 

end