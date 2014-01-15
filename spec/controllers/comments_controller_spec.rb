require 'spec_helper'

describe CommentsController do
  
  before do
    @user = FactoryGirl.create(:user)
    @commenter = FactoryGirl.create(:user)
    
    #request.env['warden'].stub :authenticate! => @commenter
    controller.stub :current_or_guest_user => @commenter 
  
    #request.env["HTTP_REFERER"] = user_status_update_path(:user_id => @user, :id => @status_update )
   
  end

  def valid_attributes
    article = FactoryGirl.create(:article)
    FactoryGirl.attributes_for(:comment).merge(:user_id => @commenter.id,
                                               :article_id => article.id)
  end

  def valid_session
    {}
  end

  pending 'no specs at all'

end
