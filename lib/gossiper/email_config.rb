module Gossiper
  class EmailConfig
    attr_reader :notification, :user

    def initialize(notification)
      @notification = notification
      @user         = notification.user
    end

    def to
      if user.respond_to?(:name)
        ["#{user.name} <#{user.email}>"]
      else
        [user.email]
      end
    end

    # TODO: Make configuration for default bcc
    def bcc
      []
    end

    # TODO: Make configuration for default from
    def from
    end

    # TODO: Make configuration for default cc
    def cc
      []
    end

    def template_name
      "#{notification.kind}_notification"
    end

    def template_path
      'notifications'
    end

    def subject
      I18n.t("gossiper.notifications.#{notification.kind}.subject")
    end

    def attachments
      {}
    end

    def instance_variables
      {}
    end
  end
end
