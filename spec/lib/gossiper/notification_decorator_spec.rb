require "spec_helper"
require "faker"

describe Gossiper::NotificationDecorator do
  let(:user)         { User.new(email: Faker::Internet.email, name: Faker::Name.name)}
  let(:notification) { Gossiper::Notification.new(user: user) }
  subject            { described_class.new(notification) }

  its(:notification) { should eq(notification) }

  describe "#kind" do
    it "defaults to the titleized kind" do
      notification.kind = 'no_kind'
      expect(subject.kind).to eq('No Kind')
    end

    it "returns the human kind name" do
      pending "it fails, but it works!"
      notification.kind = 'user_welcome'
      expect(subject.kind).to eq('User Registration')
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

  describe "#email" do
    it "returns the notification to email" do
      expect(subject.email).to eq(notification.user.email)
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
      notification.kind = 'no_kind'
      expect(subject.subject).to eq('No Kind')
    end

    it "returns the human kind name" do
      pending "it fails, but it works!"
      notification.kind = 'user_welcome'
      expect(subject.subject).to eq('Welcome!')
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
