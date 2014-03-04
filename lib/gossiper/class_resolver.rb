module Gossiper
  class ClassResolver

    def resolve(notification_type)
      klass = notification_type.split('_').map do |v|
        v.titleize
      end.join('')
      "Notifications::#{klass}Notification"
    end

  end
end
