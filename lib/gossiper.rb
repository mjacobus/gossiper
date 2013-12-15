require "gossiper/engine"
require "gossiper/concerns/models/notification"
require "gossiper/concerns/decorators/notification"
require "gossiper/email_config"
require "gossiper/mailer"
require "gossiper/configuration"
require "gossiper/notification_decorator"

module Gossiper

  class << self
    def configuration
      @@_config ||= Configuration.new
    end

    def configure
      yield configuration
    end
  end
end
