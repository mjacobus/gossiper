module Gossiper
  class NotificationDecorator

    attr_reader :notification

    def initialize(notification)
      @notification = notification
    end

    def method_missing(method, *args, &block)
      notification.send(method, *args, &block)
    end

    def respond_to?(method)
      notification.respond_to?(method)
    end

    def kind
      t("gossiper.notifications.#{notification.kind}.title",
        default: notification.kind.titleize
      )
    end

    def subject
      t("gossiper.notifications.#{notification.kind}.subject",
        default: kind
      )
    end

    def status
      t("gossiper.notifications.status.#{notification.status}")
    end

    def read?
      t(notification.read?.to_s)
    end

    def email
      notification.user.email
    end

    def delivered_at
      if notification.delivered_at.present?
        I18n.l(notification.delivered_at, format: :short)
      end
    end

    private

      def t(*args)
        I18n.t(*args)
      end

  end
end
