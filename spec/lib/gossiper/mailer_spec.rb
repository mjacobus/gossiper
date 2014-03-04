require 'spec_helper'

describe Gossiper::Mailer do
  let(:user)         { User.create!(name: 'User Name', email: 'user@email.com') }
  let(:notification) { Notifications::DummyNotification.create(user: user) }

  before do
    Gossiper.configure do |c|
      c.default_from     = 'from@email.com'
      c.default_cc       = 'cc@email.com'
      c.default_bcc      = 'bcc@email.com'
      c.default_reply_to = 'reply@email.com'
    end
  end

  it "inherits from ActionMailer::Base" do
    expect(described_class.send(:new)).to be_a(ActionMailer::Base)
  end

  describe'.mail_for' do
    let(:config)             { notification }
    subject                  { described_class.mail_for(notification) }

    its(:subject)            { should eq(config.subject) }
    its(:to)                 { should eq(config.to) }
    its(:cc)                 { should eq(config.cc) }
    its(:bcc)                { should eq(config.bcc) }
    its(:from)               { should eq([config.from]) }
    its(:reply_to)           { should eq([config.reply_to]) }

    it "sets attachments correctly" do
      string = subject.attachments.first.to_s
      expect(string).to include('filename=filename.jpg')
      expect(string).to include('Content-Type: image/jpeg')
    end

    it "assigns the notification decorator to the template" do
      expect(subject.body.encoded).to match("Decorator: Gossiper::NotificationDecorator")
    end

    it "assigns the correct vars to the correct template" do
      expect(subject.body.encoded).to match("template_name: #{config.template_name}")
      expect(subject.body.encoded).to match("template_path: #{config.template_path}")
    end

    it "renders the correct template" do
      expect(subject.body.encoded).to match('Hello Some Variable')
    end
  end

end
