class ChatsController < ApplicationController

  # GET /chats/new
  # GET /chats/new.json
  def new
    
    user_1 = User.find params[:one]
    user_2 = User.find params[:two]
    
    @chat = Chat.new(:user1 => user_1, :user2 => user_2)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @chat }
    end
  end

  # POST /chats
  # POST /chats.json
  def create
    user_1 = User.find(params[:one])
    user_2 = User.find(params[:two])
    
    @chat = Chat.new(params[:chat])
    @chat.user1 = user_1
    @chat.user2 = user_2
    
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
end
