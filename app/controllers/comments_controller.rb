class CommentsController < ApplicationController

  before_filter :authenticate_user!

  # TODO make ready for comments on talks
  def create
    authorize! :create, Comment

    venue = Venue.find(params[:venue_id])
    comment = venue.comments.build(comment_params)
    comment.user = current_user

    if comment.save
      send_email(comment, venue.users)
      redirect_to url_for(action: :show, controller: :venues, id: venue.id, anchor: "comments"),
        notice: I18n.t('comments.comment_created')
    else
      errors = comment.errors.full_messages.join(', ')
      redirect_to venue, alert: errors
    end
  end

  private

  # TODO do not create a job for every user (use custom job in app/jobs)
  def send_email(comment, users)
    users.each do |user|
      UserMailer.delay(queue: 'mail').new_comment(comment, user)
    end
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
  
end
