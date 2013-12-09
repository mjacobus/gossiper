module Gossiper
  class Configuration

    class << self
      def attribute(name, default_value = nil)
        define_method name do
          instance_variable_get("@#{name}") || default_value
        end

        define_method "#{name}=" do |value|
          instance_variable_set("@#{name}", value.to_s)
        end
      end
    end

    attribute :notifications_root_folder
    attribute :notifications_test_folder
    attribute :default_notification_user_class
    attribute :default_notification_config_class
    attribute :default_from
    attribute :default_cc
    attribute :default_bcc

    def authorize_with(&block)
      if block_given?
        @authorize_with = block
      end
      @authorize_with ||= Proc.new {}
    end
  end
end
