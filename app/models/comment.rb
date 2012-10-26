class Comment < ActiveRecord::Base
  
  attr_accessible :content, :commentable_id, :commentable_type, :user_id, :user

  belongs_to :commentable, :polymorphic => true
  belongs_to :user
  #default_scope :order => 'created_at DESC'
  
  
  validates :user_id, :presence => true
  validates :commentable_id, :presence => true
  validates :commentable_type, :presence => true
  validates :content, :presence => true
  
  after_create :generate_notification
  
  private
  
  def generate_notification
    unless commentable.user == self.user
      Notification::NewComment.create(:user => commentable.user, 
                                      :other => self.user, 
                                      :url => Rails.application.routes.url_helpers.user_status_update_url(:user_id => commentable.user, :id => commentable, :only_path => true) )
    end
  end
  
end
