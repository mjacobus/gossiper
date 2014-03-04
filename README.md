# Gossiper

Helps to manage the user notification process.

[![Build Status](https://travis-ci.org/mjacobus/gossiper.png?branch=master)](https://travis-ci.org/mjacobus/gossiper)
[![Coverage Status](https://coveralls.io/repos/mjacobus/gossiper/badge.png)](https://coveralls.io/r/mjacobus/gossiper)
[![Code Climate](https://codeclimate.com/github/mjacobus/gossiper.png)](https://codeclimate.com/github/mjacobus/gossiper)
[![Dependency Status](https://gemnasium.com/mjacobus/gossiper.png)](https://gemnasium.com/mjacobus/gossiper)
[![Gem Version](https://badge.fury.io/rb/gossiper.png)](http://badge.fury.io/rb/gossiper)

## Instalation

Add this line to your application's Gemfile:

    gem 'gossiper'

And then execute:

    $ bundle
    $ rails g gossiper:install
    $ rakegossiper:install:migrations
    $ rake db:migrate

This will create the following files:

- ```app/initializers/gossiper.rb```
- ```config/locales/gossiper.en.yml```

## Usage

### Creating a notification in the database

```ruby
notification = Gossiper::Notification.create({ user: user, kind: 'user_welcome'  })
notification.delivered? # => false
notification.status     # => 'pending'
```

### Adding aditional data to the notification

Notification has a field called data, prepared for storing aditinal data. It will be serialized as Json.

```ruby
notification.data # {}
notification.data = { 'some' => 'data' }
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

#### Creating custom configuration

If you want to create a custom configuration for the kind ```user_welcome``` all you need to do is
to create a class like follows:

```ruby
# app/models/notifications/user_welcome_notification.rb
class Notifications::UserWelcomeNotification < Gossiper::Notification
  def bcc
    [ notification.user.boss.email  ]
  end
end
```

Do not botther manually creating notifications though. See the available generators.

You can generate a new type of message by running the following command:

    $ rails generate gossiper:notification_type invoice_available

That will create the following files:

- ```app/models/notifications/invoice_available.rb```
- ```app/views/notifications/invoice_available.html.erb```
- ```spec/models/notifications/invoice_available_spec.rb```
or
- ```test/models/notifications/invoice_available_test.rb```


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
        title: Notificação de Boas Vindas
      notifications/invoice_available:
        subject: Sua fatura já está disponível! (yay)
        title: Notificação de Invoice
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

  # The passed block is run in the controller context
  config.authorize_with do
    unless current_user.is_admin?
      redirect_to root_path, notice: 'Get out!'
    end
  end
end
```

You can also overrite the gossiper_authorization method, like follows

```ruby
# app/controllers/application.rb
class ApplicationController < ActionController::Base
  def gossiper_authorization
    raise AccessDenied unless current_user.is_admin?
  end
end
```


## TODO

- [Next features](https://github.com/mjacobus/gossiper/issues?labels=enhancement&page=1&state=open)

## Authors

- [Marcelo Jacobus](https://github.com/mjacobus)


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

** Do not forget to write tests**



