module Gossiper
  class Mailer < ActionMailer::Base

    def mail_for(notification)
      @notification = NotificationDecorator.new(notification)

      config = notification

      config.attachments.each do |filename, file|
        attachments[filename] = file
      end

      config.instance_variables.each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      mail(
        from:     config.from,
        reply_to: config.reply_to,
        to:       config.to,
        cc:       config.cc,
        bcc:      config.bcc,
        subject: config.subject,
        template_name: config.template_name,
        template_path: config.template_path
      )
    end

  end
end
