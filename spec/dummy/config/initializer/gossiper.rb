Gossiper.configure do |config|
  # Change the default user class
  configure.default_user_class = 'User'

  # change the default class of the configurations
  config.default_notification_base_class = 'Gossiper::EmailConfig'

  # change the path where the notifications should be placed
  config.notification_root_folder = Rails.root.join('app/models')

  # the notifications test folder
  config.notification_test_folder = Rails.root.join("rspec", "models")

  config.authorize_with do |controller|
    # Example:

    # unless current_user.is_admin?
    #   redirect_to root_path, notice: 'Get out!'
    # end
  end
end
