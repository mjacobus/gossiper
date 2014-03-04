require "spec_helper"
require "faker"

describe Gossiper::NotificationDecorator do
  before do
    I18n.locale = :en
  end

  let(:user)         { User.new(email: Faker::Internet.email, name: Faker::Name.name)}
  let(:notification) { UserNotification.new(user: user) }
  subject            { described_class.new(notification) }

  its(:notification) { should eq(notification) }

  describe "#kind" do
    it "defaults to the titleized kind" do
      I18n.locale = 'pt-BR'
      expect(subject.kind).to eq('User Notification')
    end

    it "returns the human kind name" do
      expect(subject.kind).to eq('The Title')
    end
  end

  describe "#delivered_at" do
    it "returns nil when no date is set" do
      notification.delivered_at = nil
      expect(subject.delivered_at).to be_nil
    end

    it "returns the localized date" do
      now = Time.now.utc
      notification.delivered_at = now
      expect(subject.delivered_at).to eq(I18n.l(now, format: :short))
    end
  end

  describe "#read?" do
    it "returns the boolean translation" do
      notification.read = true
      expect(subject.read?).to eq(I18n.t('true'))
    end
  end

  describe "#status" do
    it "returns internationalized status" do
      notification.status = 'pending'
      expect(subject.status).to eq(I18n.t('gossiper.notifications.status.pending'))

      notification.status = 'delivered'
      expect(subject.status).to eq(I18n.t('gossiper.notifications.status.delivered'))
    end
  end

  describe "#subject" do
    it "defaults to the titleized kind" do
      I18n.locale = 'pt-BR'
      expect(subject.subject).to eq('User Notification')
    end

    it "returns the human kind name" do
      expect(subject.subject).to eq('The Subject')
    end
  end

  # Time fields
  %w(created_at updated_at).each do |method|
    describe "##{method}"  do
      let(:time) { Time.now.utc }

      it "returns localized time" do
        notification.send("#{method}=", time)
        expect(subject.send(method)).to eq(I18n.l(time, format: :short))
      end

      it "returns localized data" do
        notification.send("#{method}=", time)
        expect(subject.send(method)).to eq(I18n.l(time, format: :short))
      end
    end
  end

  describe "#email_object" do
    it "returns the email object for the notification" do
      Gossiper::Mailer.should_receive(:mail_for).with(notification).and_return('mail')
      expect(subject.email_object).to eq('mail')
    end
  end
end

describe Gossiper::NotificationDecorator, "#method_missing" do
  subject do
    class DummyDecorated
      def missing
        'value'
      end
    end
    described_class.new(DummyDecorated.new)
  end

  it "forwards the method call to the decorated object" do
    expect(subject.missing).to eq('value')
  end

  it "delegates to the notification" do
    expect(subject.respond_to?(:missing)).to be_true
  end
end

describe Gossiper::NotificationDecorator, "#to" do
  let(:user) { User.new(name: 'User Name', email: 'user@email.com') }
  let(:user_notification) { UserNotification.new(user: user) }
  let(:guest_notification) { GuestNotification.new(to: 'some@email.com') }

  it "returns the user email when it is a user notification" do
    subject = described_class.new(user_notification)
    expect(subject.to).to eq('User Name <user@email.com>')
  end

  it "returns the user email when it is a user notification" do
    subject = described_class.new(guest_notification)
    expect(subject.to).to eq('some@email.com')
  end
end
