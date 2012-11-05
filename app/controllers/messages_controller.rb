class MessagesController < ApplicationController
  
  layout 'dashboard'
  
  before_filter :authenticate_user!
  
  # GET /messages
  # GET /messages.json
  def index
    @user = User.find(params[:user_id])
    @messages = @user.message_queue
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @messages }
    end
  end

  # GET /messages/1
  # GET /messages/1.json
  def show
    @message = Message.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @message }
    end
  end

  # GET /messages/new
  # GET /messages/new.json
  def new
    @message = Message.new
    @user = User.find(params[:receiver_id])
    @message.receiver = @user
    
    respond_to do |format|
      format.html # new.html.erb
      format.js { render }
    end
  end


  # POST /messages
  # POST /messages.json
  def create
    @message = Message.new(params[:message])
    _receiver = User.find(params[:receiver_id])
    @message.sender = current_user
    @message.receiver = _receiver
    
    respond_to do |format|
      if @message.save
        format.html { redirect_to user_conversations_path(:user_id => @message.sender), notice: 'Message was successfully created.' }
        format.json { render json: @message, status: :created, location: @message }
        format.js { flash.now[:notice] = "Message was successfully created" }
      else
        format.html { render action: "new" }
        format.json { render json: @message.errors, status: :unprocessable_entity }
      end
    end
  end


  # DELETE /messages/1
  # DELETE /messages/1.json
  def destroy
    @message = Message.find(params[:id])
    if @message.destroy_for(current_user)
      logger.debug("Messages#destroy - #{@message.inspect}")
      flash[:notice] = "Message destroyed"
    else
      flash[:error] = "was not able to destroy message..."
    end

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :no_content }
    end
  end
end
