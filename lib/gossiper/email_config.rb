module Gossiper
  class EmailConfig
    attr_reader :notification, :user

    def initialize(notification)
      @notification = notification
      @user = notification.user rescue nil
    end

    def from
      config.default_from
    end

    def reply_to
      config.default_reply_to.presence || config.default_from
    end

    def to
      if user.respond_to?(:name)
        ["#{user.name} <#{user.email}>"]
      else
        [user.email]
      end
    end

    def bcc
      config.default_bcc
    end

    def cc
      config.default_cc
    end

    def template_name
      "#{notification.kind}_notification"
    end

    def template_path
      'notifications'
    end

    def subject
      I18n.t("gossiper.notifications.#{notification.kind}.subject", subject_variables)
    end

    def attachments
      {}
    end

    def instance_variables
      {}
    end

    def subject_variables
      {}
    end

    private
      def config
        Gossiper.configuration
      end
  end
end
