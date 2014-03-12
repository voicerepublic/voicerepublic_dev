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
class UserMailer < ActionMailer::Base

  default from: "service@voicerepublic.com"

  # app/models/talk.rb:140 (delayed)
  def new_talk(talk, user)
    return if talk.venue.options[:no_email]
    interpolate! user, talk, url: venue_talk_url(:en, talk.venue, talk)
    default_mail user.email_with_name
  end

  # lib/tasks/talks.rake:9
  def reminder(talk, user)
    return if talk.venue.options[:no_email]
    interpolate! user, talk, url: venue_talk_url(:en, talk.venue, talk)
    default_mail user.email_with_name
  end

  # app/controllers/articles_controller.rb:120 (delayed)
  def new_article(article, user)
    return if article.venue.options[:no_email]
    interpolate! user, article, url: venue_article_url(:en, article.venue, article)
    default_mail user.email_with_name
  end

  # app/controllers/comments_controller.rb:25 (delayed)
  def new_comment(comment, user)
    return if comment.article.venue.options[:no_email]
    interpolate! user, comment
    interpolate! url: venue_article_url(:en, comment.article.venue, comment.article)
    default_mail user.email_with_name
  end

  private

  # send an email with default template
  def default_mail(to)
    @header  = translate('.header')
    @content = translate('.content')
    @footer  = translate('.footer')
    mail to: to, template_name: 'default'
  end

  # merge entries into instance interpolations hash
  def interpolate!(*args)
    @interpolations ||= HashWithIndifferentAccess.new
    args.each do |object|
      case object
      when Hash then @interpolations.merge!(object)
      when ActiveRecord::Base
        ns = object.class.name.underscore
        object.attributes.each do |key, value|
          next if value.nil?
          @interpolations[[ns, key] * '_'] = value
        end
      else raise "Do not know how to merge #{object.class.name}"
      end
    end
  end

  # lookup translation with interpolations and scope
  def translate(key)
    I18n.t(key, @interpolations.merge(scope: [mailer_name, action_name]))
  end

end
