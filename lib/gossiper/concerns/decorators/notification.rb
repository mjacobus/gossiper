module Gossiper
  module Concerns
    module Decorators
      module Notification
        extend ActiveSupport::Concern

        included do
          attr_reader :notification
        end

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
          t("gossiper.notifications.#{notification.type.underscore}.title",
            default: notification.type.titleize
          )
        end

        def subject
          t("gossiper.notifications.#{notification.type.underscore}.subject",
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
        alias_method :to, :email

        def delivered_at
          decorate_date(notification.delivered_at)
        end

        def created_at
          decorate_date(notification.created_at)
        end

        def updated_at
          decorate_date(notification.updated_at)
        end

        def email_object
          @email_object ||= Mailer.mail_for(notification)
        end

        private

        def t(*args)
          I18n.t(*args)
        end

        def decorate_date(date)
          I18n.l(date, format: :short) if date
        end
      end
    end
  end
end
