def create_user
  User.create!({
    name: Faker::Name.name,
    email: Faker::Internet.email
  })
end

def create_notification(user, kind, params = {})
  Gossiper::Notification.create!({
    user: user,
    kind: kind
  }.merge(params))
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

  notification = create_notification(user, 'user_welcome', {
    read: rand(2),
  })
end

