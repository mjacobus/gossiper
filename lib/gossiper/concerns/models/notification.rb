module Gossiper
  module Concerns
    module Models
      module Notification
        extend ActiveSupport::Concern

        STATUSES = %w(pending delivered)

        included do
          include Gossiper::Concerns::Models::EmailSettings
          serialize :data, JSON
          belongs_to :user, polymorphic: true
        end

        def status
          read_attribute(:status).presence || STATUSES.first
        end

        def data
          read_attribute(:data).presence || {}
        end

        def method_missing(method, *args, &block)
          STATUSES.each do |status|
            if method.to_s == "#{status}?"
              return self.status == status
            end
          end
          super(method, *args, &block)
        end

        module ClassMethods
          def require_user
            include Gossiper::Concerns::Models::UserNotification
          end
        end

        def mail
          Gossiper::Mailer.mail_for(self)
        end

        private

          def update_delivered_at!
            self.delivered_at = Time.now
            save!
          end

      end
    end
  end
end
