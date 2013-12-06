# Gossiper

Helps to manage the user notification process.

**Important**

Gossiper is not fully implemented yet. In fact, just a little part of it is. This page is mostly a "TODO" list. If you like the idea, feel free to contribute.

## Instalation

Add this line to your application's Gemfile:

    gem 'gossiper'

And then execute:

    $ bundle
    $ rails g gossiper:install

## Usage

### Creating a notification in the database

```ruby
notification = Gossiper::Notification.create({ user: user, kind: 'user_welcome'  })
notification.delivered? # => false
notification.status     # => 'pending'

notification.deliver!   # deliver the message
# this will trigger the Gossiper::Mailer.mail_for(notification).deliver!
# whitch will change the notification status and delivery date
# you can also use the "bengless" deliver method

notification.delivered?   # => true
notification.status       # => 'delivered'
notification.delivered_at # => Just now
```

### A little about the internals

```ruby
email = Gossiper::Mailer.notification_for(notification)
email.deliver! # or email.deliver
```

### The configuration
Unless a custom class exist for the notification.kind, the defaults apply:

#### The default configuration

```ruby
mail_settings = Gossiper::EmailSettings.new(notification)

mail_setting.user                # => user

mail_settings.notification       # => notification

mail_settings.to                 # default to user.email, including name, if user
                                 # responds to name

mail_settings.cc                 # => nil

mail_settings.bcc                # => nil

mail_settings.subject   # defaults to
                        # I181.t('gossiper.notifications.user_welcome.subject')
                        # 'user_welcome' is the notification.kind

mail_settings.template_name      # gossiper/notifications/user_welcome.[format].erb
                                 # defaults to gossiper/notifications/:notification_type

mail_settings.instance_variables # Hash
                                 # this are the variables that will be available
                                 # on the template
                                 # You can customize that ass seen next

mail_settings.attachments # Array of files
```

### Customizing the notification kind configuration

If you want to create a custom configuration for the kind ```user_welcome``` all you need to do is
to create a class like follows:

```ruby
# app/models/notifications/user_welcome_notification.rb
class Notifications::UserWelcomeNotification < Gossiper::EmailSettings
  def bcc
    [ notification.user.boss.email  ]
  end
end
```

Do not botther manually creating notifications though. See the available generators.

### Generators
You can generate a new type of message by running the following command:

    $ rails generate gossiper:notification_type invoice_available

That will create the following files:

- app/models/notifications/invoice_available_notification.rb
- spec/models/notifications/invoice_available_notification_spec.rb
- app/notifications/invoice_available.html.erb


## Configuration

Create a  initializers/gossiper.rb, so the user can change the default to and etc, as follows

```ruby
Gossiper.configure do |config|
  # change the default class of the configurations
  config.default_delivery_base_class = 'Gossiper::EmailSettings'

  # Change the default user class
  configure.default_user_class = 'User'

  # change the notification namespace
  config.notification_namespace = 'Notifications'

  # change the path where the notifications should be placed
  config.notifications_root_folder = Rails.root.join('app/models/notifications')
end
```

## I18n (Localization, internacionalization)
TODO: write documentation


## Managing the notifications

Gossiper provides a rails engine that you can mount in order to manage notifications.

You can view, delete and resend notifications.

### Mounting the engine
```ruby
mount Gossiper::Engine, at: 'notifications'
```

Now all you need is to go to /notifications path in your application.

**IMPORTANT**
The url is publicly available by default.

## TODO
- Everything, according to the especification above, except by the notification model, which is ready.
- Provide a way of controlling the access to the mounted engine

## Authors
- [Marcelo Jacobus](https://github.com/mjacobus)

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
