class ConversationsController < ApplicationController
  layout 'dashboard'
  
  before_filter :authenticate_user!
  before_filter :set_user
  
  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = @user.conversations

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conversations }
    end
  end

  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @conversation = Conversation.find(params[:id])
    @messages = @conversation.undeleted_messages_for(@user).order("created_at DESC").paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conversation }
    end
  end


  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation = Conversation.find(params[:id])
    @conversation.destroy

    respond_to do |format|
      format.html { redirect_to user_conversations_url(:user_id => params[:user_id]) }
      format.json { head :no_content }
    end
  end
  
  private
  def set_user
    @user ||= User.find(params[:user_id])
  end
end
