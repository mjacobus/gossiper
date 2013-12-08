require "gossiper/engine"
require "gossiper/email_config"
require "gossiper/mailer"
require "gossiper/configuration"

module Gossiper

  class << self
    def configuration
      @@_config ||= Configuration.new
    end

    def config
      yield configuration
    end
  end
end
