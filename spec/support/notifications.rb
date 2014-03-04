class UserNotification < Gossiper::Notification
  require_user
end

class GuestNotification < Gossiper::Notification
end

