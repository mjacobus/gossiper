class Gossiper::NotificationTypeGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_class_file
    template 'notification_type.rb', File.join(
      Gossiper.configuration.notifications_root_folder.to_s,
      'notifications',
      class_path,
      "#{singular_name}_notification.rb"
    )
  end

  def create_test_file
    test_sufix = defined?(RSpec) ? 'spec' : 'test'

    template 'notification_type_test.rb', File.join(
      Gossiper.configuration.notifications_test_folder.to_s,
      'notifications',
      class_path,
      "#{singular_name}_notification_#{test_sufix}.rb"
    )
  end

  def create_template
  end
end
