require 'rails_helper'

describe Mediator do

  before do
    @mediator = Mediator.new
  end

  it 'handle dj_callbacks' do
    expect(@mediator).to respond_to(:dj_callback)
  end

  it 'handle purchase_events' do
    expect(@mediator).to respond_to(:purchase_event)
  end

  it 'handle talk_transitions' do
    expect(@mediator).to respond_to(:talk_transition)
  end

end
