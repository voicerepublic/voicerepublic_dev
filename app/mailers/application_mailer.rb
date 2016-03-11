class ApplicationMailer < ActionMailer::Base
  default from: Settings.devise.from_address
  layout 'mailer'

  private
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

  # send an email with a template
  def default_mail(to, from = nil, template = 'default', subject=nil)
    @header  = translate('.header')
    @content = translate('.content')
    @content_plain = translate('.content_plain')
    @footer  = translate('.footer')

    options = {
      to: to,
      template_name: template
    }
    options[:from] = from unless from.nil?
    options[:subject] = subject unless subject.nil?
    options['x-mailgun-native-send'] = true if to.contains '@voicerepublic.com'

    mail options
  end

end
