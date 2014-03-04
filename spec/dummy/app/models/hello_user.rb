class HelloUser < Gossiper::Notification
  require_user
  # validates :user, presence: true
end
