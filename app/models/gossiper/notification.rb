module Gossiper
  class Notification < ActiveRecord::Base
    STATUSES = %w(pending delivered)

    validates :kind, presence: true

    def user
      @user ||= user_class.constantize.find(user_id)
    end

    def user_class
      read_attribute(:user_class).presence || 'User'
    end

    def status
      read_attribute(:status).presence || STATUSES.first
    end

    def deliver
      mail.deliver
      update_delivered_at!
    end

    def deliver!
      mail.deliver!
      update_delivered_at!
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
