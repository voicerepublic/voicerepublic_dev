class ChatsController < ApplicationController
  include ActionView::Helpers::JavaScriptHelper 
  before_filter :authenticate_user!
  
  # GET /chats/new
  # GET /chats/new.json
  def new
    @recipient = User.find(params[:user_id])
    @sender = current_user
    
    @chat = Chat.new(:user1 => @receiver, :user2 => @sender)
    @chat.sender = @sender
    @chat.recipient = @recipient
    
    # send notification via push to subscribe to chat-channel
    
    #if user1.available? 
      #logger.debug("Chats#new - user1 is available")
      content = render_to_string( :partial => 'chat_window', :locals => { :chat => @chat, :partner => @sender } )
      js = "chat.build('#{escape_javascript(content)}', true);"
      ret = PrivatePub.publish_to( "/notifications/#{@recipient.id}", js)
      Rails.logger.debug("#{self.class.name}#new - sent notification to the one beeing connected \nret: #{ret.inspect}\n")
    #else
    #  logger.debug("Chats#new - user1 is NOT available")
    #end
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chat }
      format.js 
      #  unless  user1.available? 
      #    @user = user1
      #    flash.now[:error] = "#{user1.name} is busy"
      #    render(:partial => 'busy') and return 
      #  end
      #end
    end
  end
  

  # POST /chats
  # POST /chats.json
  def create
    
    @chat = Chat.new(params[:chat])
    @chat.user1 = User.find(params[:one])
    @chat.user2 = User.find(params[:two])
    @chat.sender = current_user
    @chat.recipient = current_user == @chat.user1 ? @chat.user2 : @chat.user1
    
    logger.debug("Chats#create - about to create chat message: #{@chat.inspect}")
    respond_to do |format|
      if @chat.save
        format.html { redirect_to new_chat_path(:one => @chat.recipient_for(@chat), :two => current_user ), notice: 'Chat was successfully created.' }
        format.json { render json: @chat, status: :created, location: @chat }
        format.js 
      else
        format.html { render action: "new" }
        format.json { render json: @chat.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chats/1
  # DELETE /chats/1.json
  def destroy
    user_1, user_2 = User.find(params[:one]), User.find(params[:two])
    @chat = Chat.new(:user1 => user_1, :user2 => user_2 )

    sender = current_user
    recipient = current_user == user_1 ? user_2 : user_1
    @chat.sender = sender
    @chat.recipient = recipient
    
    respond_to do |format|
      format.html { redirect_to chats_url }
      format.json { head :no_content }
      format.js
    end
  end
  
  # TODO complete functionality - 
  # if user clicks while having chat open
  # frontend will call this method to rebuild chat 
  # based on already submitted chat-messages
  #
  def show
    @conversation = Conversation.find(params[:id])
    @chat = Chat.new 
    logger.debug("Chats#show - showing conversation for chat-view")
    respond_to do |format|
      format.js
    end  
  end
end
