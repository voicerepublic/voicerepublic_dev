class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    article = Article.find(params[:article_id])
    venue = article.venue
    comment = article.comments.build(params[:comment])
    comment.user = current_or_guest_user

    if comment.save
      send_notification(comment)
      redirect_to venue, notice: 'Comment was created.'
    else
      errors = comment.errors.full_messages.join(', ')
      redirect_to venue, alert: errors
    end
  end

  private

  def send_notification(comment)
    users = comment.article_venue.attendees - [current_or_guest_user]
    users.each do |user|
      UserMailer.new_comment_notification(comment, user).deliver
    end
  end

end
