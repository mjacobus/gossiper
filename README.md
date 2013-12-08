# Gossiper

Helps to manage the user notification process.

[![Build Status](https://travis-ci.org/mjacobus/gossiper.png?branch=master)](https://travis-ci.org/mjacobus/gossiper)
[![Coverage Status](https://coveralls.io/repos/mjacobus/gossiper/badge.png)](https://coveralls.io/r/mjacobus/gossiper)
[![Gem Version](https://badge.fury.io/rb/gossiper.png)](http://badge.fury.io/rb/gossiper)

**Important**

Gossiper is not fully implemented yet. See the "TODO" section so you know what parts of the following instructions are in fact a specification of what need to be done. If you like the idea, feel free to contribute.

## Instalation

Add this line to your application's Gemfile:

    gem 'gossiper'

And then execute:

    $ bundle
    $ rails g gossiper:install

This will create the following files:

- ```app/initializers/gossiper.rb```
- ```config/locales/gossiper.en.yaml```

## Usage

### Creating a notification in the database

```ruby
notification = Gossiper::Notification.create({ user: user, kind: 'user_welcome'  })
notification.delivered? # => false
notification.status     # => 'pending'
```

### Delivering notifications

```Ruby
notification.deliver!   # deliver the message

notification.delivered?   # => true
notification.status       # => 'delivered'
notification.delivered_at # => Just now
```

Also, you could delivery a notification this way:

```ruby
email = Gossiper::Mailer.notification_for(notification)
email.deliver! # or email.deliver
```

### The notification Config
Unless a custom class exist for the notification.kind, the defaults apply:

#### The default configuration

```ruby
mail_settings = Gossiper::EmailConfig.new(notification)

mail_setting.user                # => user

mail_settings.notification       # => notification

mail_settings.to                 # default to user.email, including name, if user
                                 # responds to name

mail_settings.cc                 # => nil

mail_settings.bcc                # => nil

mail_settings.subject   # defaults to
                        # I181.t('gossiper.notifications.user_welcome.subject')
                        # 'user_welcome' is the notification.kind

mail_settings.template_name      # user_welcome_notifcation
                                 # defaults to {notification_type}_notification

mail_settings.template_path      # notification

mail_settings.instance_variables # Hash
                                 # this are the variables that will be available
                                 # on the template
                                 # You can customize that ass seen next

mail_settings.attachments # Array of files
```

#### Creating custom configuration

If you want to create a custom configuration for the kind ```user_welcome``` all you need to do is
to create a class like follows:

```ruby
# app/models/notifications/user_welcome_notification.rb
class Notifications::UserWelcomeNotification < Gossiper::EmailConfig
  def bcc
    [ notification.user.boss.email  ]
  end
end
```

Do not botther manually creating notifications though. See the available generators.

You can generate a new type of message by running the following command:

    $ rails generate gossiper:notification_type invoice_available

That will create the following files:

- ```app/models/notifications/invoice_available_notification.rb```
- ```spec/models/notifications/invoice_available_notification_spec.rb```
- ```app/notifications/invoice_available.html.erb```


## Configuration

You can customize gossiper behavior by editing the ```config/initializer/gossiper.rb```

## I18n (Localization, internacionalization)

You can internationalize titles by editing the ```config/gossiper.{locale}.yml``` file, as follows:

```yaml
pt-BR:
  gossiper:
    notifications:
      user_welcome:
        subject: Bem vindo!
      invoice_available:
        subject: Sua fatura já está disponível! (yay)
```


## Managing the notifications

Gossiper provides a rails engine that you can mount in order to manage notifications.

You can view, delete and resend notifications.

### Mounting the engine

```ruby
mount Gossiper::Engine, at: 'notifications'
```

Now all you need is to go to /notifications path in your application.

#### The engine access control

You change the configuration file like follows:

```ruby
Gossiper.configure do |config|
  config.authorize_with do |controller|
    unless current_user.is_admin?
      redirect_to root_path, notice: 'Get out!'
    end
  end
end
```


## TODO

- The notification management engine
- Access Control in the engine

## Authors

- [Marcelo Jacobus](https://github.com/mjacobus)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
