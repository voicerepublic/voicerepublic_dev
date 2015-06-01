# If you don't pass a subject to the mail method, Action Mailer will
# try to find it in your translations. The performed lookup will use
# the pattern <mailer_scope>.<action_name>.subject to construct the
# key.
#
# Action Mailer will automatically send multipart emails if you have
# different templates for the same action. So, for our UserMailer
# example, if you have welcome_email.text.erb and
# welcome_email.html.erb in app/views/user_mailer, Action Mailer will
# automatically send a multipart email with the HTML and text versions
# setup as different parts.
#
class UserMailer < ApplicationMailer

  # app/models/talk.rb:130 (delayed)
  def new_talk(talk, user)
    return if talk.venue.opts.no_email
    attachments.inline['flyer.png'] = File.read(Rails.root.join('public', talk.flyer.path[1..-1])) if talk.flyer.exist?
    flyer = ActionController::Base.helpers.image_tag attachments['flyer.png'].url
    interpolate! user, talk, url: talk_url(talk), flyer: flyer,
      name: [talk.venue.title, talk.title].join(' - ')
    default_mail user.email_with_name
  end

  # lib/tasks/talks.rake:10
  def reminder(talk, user)
    return if talk.venue.opts.no_email
    interpolate! user, talk, url: talk_url(talk),
      name: [talk.venue.title, talk.title].join(' - ')

    # preview with attachments are broken and will be fixed here
    # https://github.com/rails/rails/commit/29fc2e26dc821c46a0ba04ed3772bca92ccc7866
    unless Settings.no_attachments
      flyer =  File.read(Rails.root.join('public', talk.flyer.path[1..-1]))
      attachments.inline['flyer.png'] = flyer
      flyer_url = attachments.inline['flyer.png'].url
      flyer_img = ActionController::Base.helpers.image_tag(flyer_url)
      interpolate! flyer: flyer_img
    else
      interpolate! flyer: "(Sorry, developers don't get to see an image!)"
    end

    default_mail user.email_with_name
  end

  # app/controllers/comments_controller.rb:25 (delayed)
  def new_comment(comment, user)
    # FIXME: This needs to be rewritten since Comments have been rewritten
    venue, url = nil, nil
    case comment.commentable
    when Venue
      venue = comment.commentable
      url = venue_url(id: venue.id)
    when Talk
      talk = comment.commentable
      venue = talk.venue
      url = venue_talk_url(venue_id: venue.id, id: talk.id)
    end
    interpolate! user, comment
    interpolate! url: url
    default_mail user.email_with_name
  end

  # TODO: A welcome mail should be send directly after user creation. A stub is
  # already available at app/concerns/welcomed.rb
  def welcome(user)
    interpolate! user
    default_mail user.email_with_name
  end

end
