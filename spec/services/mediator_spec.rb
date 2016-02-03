require 'rails_helper'

describe Mediator do

  before do
    @mediator = Mediator.new
  end

  it 'handle dj_callback' do
    expect(@mediator).to respond_to(:dj_callback)

    payload = {
      'event' => 'success',
      'job' => {
        'handler' => 'struct:Postprocess'
      },
      'opts' => {
        'id' => 42
      }
    }
    expectation = {
      x: 'notification',
      text: 'Postprocessing of Talk 42 is complete.'
    }
    expect(@mediator.dj_callback(nil, nil, payload, nil)).to eq(expectation)
  end

  it 'handle transaction_transition' do
    expect(@mediator).to respond_to(:transaction_transition)
  end

  it 'handle talk_transition' do
    expect(@mediator).to respond_to(:talk_transition)
  end

end
