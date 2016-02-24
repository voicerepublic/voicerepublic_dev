require 'rails_helper'

describe Mediator::DjCallback do

  before do
    @handler = Mediator::DjCallback
  end

  it 'works' do
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
    expect(@handler.call(payload)).to eq(expectation)
  end

end
