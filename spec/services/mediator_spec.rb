require 'rails_helper'

describe Mediator do

  before do
    @mediator = Mediator.new
  end

  it 'handle talk_transition' do
    expect(@mediator).to respond_to(:talk_transition)
  end

end
