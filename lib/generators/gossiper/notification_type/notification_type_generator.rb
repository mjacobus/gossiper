class Gossiper::NotificationTypeGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)


  def create_class_file
    template 'notification_type.rb',
      File.join('app/models/notifications', class_path, "#{singular_name}_notification.rb")
  end

  def create_test_file
    if defined?(RSpec)
      template 'notification_type_spec.rb',
        File.join('spec/models/notifications', class_path, "#{singular_name}_notification_spec.rb")
    else
      template 'notification_type_test.rb',
        File.join('test/models/notifications', class_path, "#{singular_name}_notification_test.rb")
    end
  end
end
