module Notifications
  class UserNotification < Gossiper::Notification
    require_user
  end
end
