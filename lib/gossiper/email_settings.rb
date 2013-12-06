module Gossiper
  class EmailSettings
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

    def bcc
      []
    end

    def cc
      []
    end

    def template
      "notifications/#{notification.kind}"
    end
  end
end
