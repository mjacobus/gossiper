module Gossiper
  module Concerns
    module Models
      module Notification
        extend ActiveSupport::Concern

        STATUSES = %w(pending delivered)

        included do
          serialize :data, JSON
          validates :kind, presence: true
          belongs_to :user, polymorphic: true
        end

        def status
          read_attribute(:status).presence || STATUSES.first
        end

        def data
          read_attribute(:data).presence || {}
        end

        def deliver
          mail.deliver
          update_delivered_at!
        end

        def deliver!
          mail.deliver!
          update_delivered_at!
        end

        def kind=(value)
          value = value.present? ? value.parameterize.underscore : nil
          write_attribute(:kind, value)
        end

        def config
          ClassResolver.new.resolve(kind).constantize.new(self)
        end

        def method_missing(method, *args, &block)
          STATUSES.each do |status|
            if method.to_s == "#{status}?"
              return self.status == status
            end
          end
          super(method, *args, &block)
        end

        protected
          def mail
            Gossiper::Mailer.mail_for(self)
          end

          def update_delivered_at!
            self.delivered_at = Time.now
            save!
          end

      end
    end
  end
end
