require 'net/smtp'

class Email
  def self.send(to,opts={})
    opts[:server]      ||= 'localhost'
    opts[:from]        ||= 'ci@voicerepublic.com'
    opts[:from_alias]  ||= 'CI VoiceRepublic'
    opts[:subject]     ||= "Failed spec run"

    msg = <<END_OF_MESSAGE
From:#{opts[:from_alias]} <#{opts[:from]}>
To:<#{to}>
Subject:#{opts[:subject]}

#{opts[:body]}
END_OF_MESSAGE

    Net::SMTP.start(opts[:server]) do |smtp|
      smtp.send_message msg, opts[:from], to
    end
  end
end

