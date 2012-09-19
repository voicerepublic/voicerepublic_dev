module MessagesHelper
  
  def partial_for_message(message,user)
    if message.receiver == user
      render(:partial => "received_message", :locals => {:message => message }) 
    else
      render(:partial => "sent_message", :locals => {:message => message })
    end
  end
end
