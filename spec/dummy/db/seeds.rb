def create_user
  User.create!({
    name: Faker::Name.name,
    email: Faker::Internet.email
  })
end

def create_notification(user = nil, klass = nil, params = {})
  default = {}
  default[:user] = user if user
  klass.create!(default.merge(params))
end

def random_status
  statuses = Gossiper::Notification::STATUSES
  statuses[rand(statuses.length)]
end

50.downto(1) do |n|
  user = create_user
  status = random_status
  sent = rand(2) == 1
  delivered_at = status == 'delivered' ? (n*355).minutes.ago : nil

  notification = create_notification(user, Notifications::UserNotification, {
    read: rand(2),
  })

  notification = create_notification(nil, Notifications::GuestNotification, {
    read: rand(2),
    to: Faker::Internet.email
  })
end

