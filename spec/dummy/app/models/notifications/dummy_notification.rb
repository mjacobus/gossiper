module Notifications
  class DummyNotification < Gossiper::EmailConfig
    def to
      ['to@email.com']
    end

    def cc
      ['cc@email.com']
    end

    def bcc
      ['bcc@email.com']
    end

    def subject
      'The Subject'
    end

    def attachments
      {'filename.jpg' => {'file' => 'config'}}
    end

    def instance_variables
      { instance_variable: 'Some Variable', config: self }
    end
  end
end
