class ConversationsController < ApplicationController
  layout 'dashboard'
  
  before_filter :authenticate_user!
  before_filter :set_user
  
  # GET /conversations
  # GET /conversations.json
  def index
    @conversations = @user.conversations.sort { |a,b| b.undeleted_messages_for(@user).limit(1).first.created_at <=> a.undeleted_messages_for(@user).limit(1).first.created_at }
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @conversations }
    end
  end
  
  # GET /conversations/1
  # GET /conversations/1.json
  def show
    @conversation = Conversation.find(params[:id])
    
    authorize! :show, @conversation
    
    @messages = @conversation.undeleted_messages_for(@user).paginate(:page => params[:page], :per_page => 10)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @conversation }
    end
  end


  # DELETE /conversations/1
  # DELETE /conversations/1.json
  def destroy
    @conversation = Conversation.find(params[:id])
    
    authorize! :destroy, @conversation 
    
    @conversation.destroy

    respond_to do |format|
      format.html { redirect_to user_conversations_url(:user_id => params[:user_id]), notice: I18n.t('controller_conversations.conversation_destroyed', :default => 'conversation destroyed') }
      format.json { head :no_content }
    end
  end
  
  private
  def set_user
    @user ||= User.find(params[:user_id])
  end
end
