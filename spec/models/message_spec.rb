require 'spec_helper'

# for these specs the faye message proxy has to run!
describe Message do

  it "is invalid without sender" do
    FactoryGirl.build(:message, :sender => false).should_not be_valid
  end
  
  it "is invalid without receiver" do
    FactoryGirl.build(:message, :receiver => false).should_not be_valid
  end
  
  
  it "belongs to a conversation after creation" do
    c = FactoryGirl.create(:message)
    c.conversation.should be_valid
  end
  
  
  it "has a conversation that belongs to both involved users of the conversations" do
    m = FactoryGirl.create(:message)#, :sender_id => s.id, :receiver_id=> r.id)
    [m.sender, m.receiver].should include(m.conversation.user_1) 
    [m.sender, m.receiver].should include(m.conversation.user_2)  
  end
  
  
  it "is invalid without content" do
    FactoryGirl.build(:message, :content => " ").should_not be_valid
  end
  
  it "will not be destroyed if only sender or receiver deleted the message" do
    m = FactoryGirl.create(:message)
    m.destroy_for(m.sender).should be_true
    Message.find(m.id).should be_valid
  end
  
  it "will be destroyed if both sender and receiver deleted the message" do
    m = FactoryGirl.create(:message)
    id = m.id
    m.destroy_for(m.sender).should be_true
    m.destroy_for(m.receiver).should be_true
    expect {
      Message.find(id)
    }.to raise_error
  end
end
