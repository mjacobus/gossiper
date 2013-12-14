require 'spec_helper'

class DummyUser < Struct.new(:id)
  def self.find(id)
    new(id)
  end
end

describe Gossiper::Notification, "#data" do
  it "defaults to empty hash" do
    expect(subject.data).to eq({})
  end

  it "serializes data as json" do
    user = stub_model(User, id: 1)
    subject = described_class.create!({ user: user, kind: 'some_kind' })
    data = {'some_data' => 'some_value' }
    subject.data = data
    expect(subject.data).to be(data)
    subject.save!
    subject.reload
    expect(subject.data).to eq(data)
  end
end

describe Gossiper::Notification, "#deliver" do
  it "calls deliver on the mail object and updates the delivery date" do
    mail = double(:mail)
    subject.stub(mail: mail)

    mail.should_receive(:deliver)
    subject.should_receive(:update_delivered_at!)

    subject.deliver
  end
end

describe Gossiper::Notification, "#deliver" do
  it "calls deliver on the mail object and updates the delivery date" do
    mail = double(:mail)
    subject.stub(mail: mail)

    mail.should_receive(:deliver!)
    subject.should_receive(:update_delivered_at!)

    subject.deliver!
  end
end

describe Gossiper::Notification, "#delivered" do
  it "returns boolean indicationg if the notification was delivered" do
    expect do
      subject.status = 'delivered'
    end.to change { subject.delivered? }.from(false).to(true)
  end
end

describe Gossiper::Notification, "#delivered_at" do
  it { should respond_to(:delivered_at) }
  it { should respond_to(:delivered_at=) }
end

describe Gossiper::Notification, "#kind" do
  it "is required" do
    subject.should validate_presence_of(:kind)
  end

  it "underscores kinds" do
    subject.kind = 'a  kind'
    expect(subject.kind).to eq('a_kind')
  end
end

describe Gossiper::Notification, "#mail" do
  it "returns the email about to be send" do
    Gossiper::Mailer.should_receive(:mail_for).with(subject).and_return('mail')
    expect(subject.send(:mail)).to eq('mail')
  end
end

describe Gossiper::Notification, "#read?" do
  it "returns boolean indicationg if the message was read" do
    subject.read = '1'
    expect(subject.read?).to be_true

    subject.read = '0'
    expect(subject.read?).to be_false
  end
end

describe Gossiper::Notification::STATUSES do
  it "returns boolean indicationg if the message was read" do
    expect(subject).to eq(['pending', 'delivered'])
  end
end

describe Gossiper::Notification, "#status" do
  it "returns the status of the notification" do
    expect { subject.status = 'delivered' }.to change {
      subject.status
    }.from('pending').to('delivered')
  end
end

describe Gossiper::Notification, "#user" do
  before do
    subject.user_class = 'DummyUser'
    subject.user_id    = 1
  end

  it "returns the user that owns the notification" do
    expect(subject.user).to be_a(DummyUser)
    expect(subject.user.id).to be(1)
  end

  it "memoizes the value" do
    expect(subject.user).to be(subject.user)
  end
end

describe Gossiper::Notification, "#user=" do
  before do
    subject.user_class = 'DummyClass'
    subject.user_id    = 1
    subject.user       = user
  end

  let(:user) { stub_model(User, id: 2) }

  it "sets the user" do
    expect(subject.user).to be(user)
  end

  it "changes the user_class" do
    expect(subject.user_class).to eq('User')
  end

  it "changes the user id" do
    expect(subject.user_id).to eq(2)
  end

  it "memoizes the value" do
    expect(subject.user).to be(subject.user)
  end
end

describe Gossiper::Notification, "#user_class" do
  it "defaults to the configured class" do
    Gossiper.configuration.default_notification_user_class = 'User'
    expect(subject.user_class).to eq('User')

    Gossiper.configuration.default_notification_user_class = 'AnotherClass'
    expect(subject.user_class).to eq('AnotherClass')
  end

  it "can be manually changed" do
    subject.user_class = 'AnotherClass'
    expect(subject.user_class).to eq('AnotherClass')
  end
end

describe Gossiper::Notification, "#update_delivered_at!" do
  it "updates the delivered date and saves" do
    now = Time.now
    Time.stub(now: now)
    subject.should_receive(:delivered_at=).with(now)
    subject.should_receive(:save!)
    subject.send(:update_delivered_at!)
  end
end

describe Gossiper::Notification, "#user_id" do
  it { should respond_to(:user_id) }
  it { should respond_to(:user_id=) }
end
