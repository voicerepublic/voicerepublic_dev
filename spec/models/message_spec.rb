require 'spec_helper'

describe Message do
  it "has a valid factory" do
    FactoryGirl.create(:message).should be_valid
  end
 
  it "is invalid without sender" do
    FactoryGirl.build(:message, :sender => false).should_not be_valid
  end
  
  it "is invalid without receiver" do
    FactoryGirl.build(:message, :receiver => false).should_not be_valid
  end
  
  it "belongs to a sender_conversation after creation" do
    c = FactoryGirl.create(:message)
    c.sender_conversation.should be_valid
  end
  
  it "belongs to a receiver_conversation after creation" do
    c = FactoryGirl.create(:message)
    c.receiver_conversation.should be_valid
  end
  
  it "has a receiver_conversation after creation" do
    c = FactoryGirl.create(:message)
    c.receiver_conversation.should be_valid
  end
  
  it "has a receiver_conversation that belongs to receivers conversations" do
    m = FactoryGirl.create(:message)#, :sender_id => s.id, :receiver_id=> r.id)
    m.receiver_conversation.user.id.should eql(m.receiver.id)
  end
  
  it "has a sender_conversation that belongs to senders conversations" do
    m = FactoryGirl.create(:message)#, :sender_id => s.id, :receiver_id=> r.id)
    m.sender_conversation.user.id.should eql(m.sender.id)
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
