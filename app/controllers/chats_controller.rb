class ChatsController < ApplicationController
  include ActionView::Helpers::JavaScriptHelper 
  before_filter :authenticate_user!
  
  # GET /chats/new
  # GET /chats/new.json
  def new
    user1 = User.find params[:one]
    user2 = User.find params[:two]
    @chat = Chat.new(:user1 => user1, :user2 => user2)
    
    # send notification via push to subscribe to chat-channel
    content = render_to_string( :partial => 'chat_window', :locals => { :chat => @chat, :partner => user2 } )
    js = "overlay.build('#{escape_javascript(content)}', true);"
    ret = PrivatePub.publish_to("/notifications/#{user1.id}", js)
    Rails.logger.debug("#{self.class.name}#new - sent notification to the one beeing connected \nret: #{ret.inspect}\n")
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chat }
      format.js 
    end
  end
  

  # POST /chats
  # POST /chats.json
  def create
    user1 = User.find(params[:one])
    user2 = User.find(params[:two])
    
    @chat = Chat.new(params[:chat])
    @chat.user1 = user1
    @chat.user2 = user2
    
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
