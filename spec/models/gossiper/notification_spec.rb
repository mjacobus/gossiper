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
  it { should belong_to(:user) }

  it "os a polymorphic association" do
    admin = AdminUser.create!(email: 'admin@email.com', name: 'Admin')
    user  = AdminUser.create!(email: 'user@email.com', name: 'User')

    admin_notification = Gossiper::Notification.create!(user: admin, kind: 'any')
    expect(admin_notification.user).to eq(admin)

    user_notification = Gossiper::Notification.create!(user: user, kind: 'any')
    expect(user_notification.user).to eq(user)
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
