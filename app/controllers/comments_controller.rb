class CommentsController < ApplicationController

  before_filter :authenticate_user!

  def create
    # venue = @article.venue
    # comment = @article.comments.build(params[:comment])
    # comment.user = current_user
    # 
    # if comment.save
    #   send_email(comment)
    #   redirect_to venue, notice: 'Comment was created.'
    # else
    #   errors = comment.errors.full_messages.join(', ')
    #   redirect_to venue, alert: errors
    # end
  end

  private

  def send_email(comment)
    users = comment.article_venue.users - [current_user]
    users.each do |user|
      UserMailer.delay(queue: 'mail').new_comment(comment, user)
    end
  end

end
