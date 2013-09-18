class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    article = Article.find(params[:article_id])
    venue = article.venue
    comment = article.comments.build(params[:comment])
    comment.user = current_user

    if comment.save
      redirect_to venue, notice: 'Comment was created.'
    else
      errors = comment.errors.full_messages.join(', ')
      redirect_to venue, alert: errors
    end
  end
end
