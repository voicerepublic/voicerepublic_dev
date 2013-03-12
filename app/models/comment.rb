class Comment < ActiveRecord::Base
  
  attr_accessible :content, :commentable_id, :commentable_type, :user_id, :user, :url

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
    
    if commentable.kind_of?(StatusUpdate)
      unless commentable.user == self.user
        Notification::NewComment.create(:user => commentable.user, 
                                      :other => self.user, 
                                      :content => self.content,
                                      :url => Rails.application.routes.url_helpers.user_status_update_path(:user_id => self.commentable.user, :id => self.commentable )
                                      )
      end
      
    end
    if commentable.kind_of?(Venue)
      # venue participants will receive a notification
      self.commentable.attendies.each do |attendie|
        unless self.user == attendie
          Notification::NewComment.create(:user => attendie,
                                      :other => self.user,
                                      :content => self.content,
                                      :url => Rails.application.routes.url_helpers.venue_path(self.commentable))
        end
      end
    end
  end
  
end
