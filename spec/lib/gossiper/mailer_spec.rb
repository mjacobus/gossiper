require 'spec_helper'

module Notifications
  class DummyKindNotification < Gossiper::EmailConfig
  end
end

describe Gossiper::Mailer do
  let(:user)         { User.create!(name: 'User Name', email: 'user@email.com') }
  let(:notification) { Gossiper::Notification.create(user: user, kind: 'dummy') }

  it "inherits from ActionMailer::Base" do
    expect(described_class.send(:new)).to be_a(ActionMailer::Base)
  end

  describe'.mail_for' do
    before do
      notification.kind = 'dummy'
    end

    let(:config)             { Notifications::DummyNotification.new(notification) }
    subject                  { described_class.mail_for(notification) }

    its(:subject)            { should eq(config.subject) }
    its(:to)                 { should eq(config.to) }
    its(:cc)                 { should eq(config.cc) }
    its(:bcc)                { should eq(config.bcc) }

    it "sets attachments correctly" do
      string = subject.attachments.first.to_s
      expect(string).to include('filename=filename.jpg')
      expect(string).to include('Content-Type: image/jpeg')
    end

    it "assigns the correct vars to the correct template" do
      expect(subject.body.encoded).to match("template_name: #{config.template_name}")
      expect(subject.body.encoded).to match("template_path: #{config.template_path}")
    end

    it "renders the correct template" do
      expect(subject.body.encoded).to match('Hello Some Variable')
    end
  end

  describe '#config_for' do
    def resolve_class(notification, klass)
      expect(described_class.send(:new).config_for(notification).class.to_s).to eq(klass.to_s)
    end

    it "resolves standard notifications config" do
      notification.kind = 'no_kind'
      resolve_class(notification, Gossiper::EmailConfig)
    end

    it "resolves custom notification config" do
      notification.kind = 'dummy_kind'
      resolve_class(notification, Notifications::DummyKindNotification)
    end
  end
end
