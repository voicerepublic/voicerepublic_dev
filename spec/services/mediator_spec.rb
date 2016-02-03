require 'rails_helper'

describe Mediator do

  before do
    @mediator = Mediator.new
  end

  it 'handle dj_callback' do
    expect(@mediator).to respond_to(:dj_callback)
  end

  it 'handle transaction_transition' do
    expect(@mediator).to respond_to(:transaction_transition)
  end

  it 'handle talk_transition' do
    expect(@mediator).to respond_to(:talk_transition)
  end

end
