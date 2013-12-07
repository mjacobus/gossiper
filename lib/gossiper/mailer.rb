module Gossiper
  class Mailer < ActionMailer::Base

    def mail_for(notification)
      config = config_for(notification)

      config.attachments.each do |filename, file|
        attachments[filename] = file
      end

      config.instance_variables.each do |name, value|
        instance_variable_set("@#{name}", value)
      end

      mail(
        to:      config.to,
        cc:      config.cc,
        bcc:     config.bcc,
        subject: config.subject,
        template_name: config.template_name,
        template_path: config.template_path
      )
    end

    def config_for(notification)
      begin
        klass = "Notifications::#{notification.kind.classify}Notification"
        klass.constantize.new(notification)
      rescue NameError
        Gossiper::EmailConfig.new(notification)
      end
    end
  end
end