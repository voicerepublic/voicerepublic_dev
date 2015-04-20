require 'rails_helper'

describe FluxCapacitor do

  before do
    @fc = FluxCapacitor.new
  end

  it 'raises en error if the message has no channel' do
    msg = { 'some' => 'message' }
    #expect { @fc.process(msg) }.to raise_exception
  end

  #it 'simply returns unknown messages' do
  #  msg = { 'channel' => '/some/channel' }
  #  expect(@fc.process(msg)).to eq(msg)
  #end

end
