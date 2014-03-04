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
    subject = described_class.create!({ user: user })
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

    admin_notification = Gossiper::Notification.create!(user: admin )
    expect(admin_notification.user).to eq(admin)

    user_notification = Gossiper::Notification.create!(user: user)
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

describe Gossiper::Notification, "#to" do
  it "returns the given email and address" do
    subject = described_class.new(to: 'some@email.com')
    expect(subject.to).to eq('some@email.com')
  end

  describe "when attached to user" do
    context "when user has a name" do
      it "returns email and name" do
        subject = HelloUser.new(to: 'some@email.com')
        user = double(email: 'user@email.com', name: 'User Name')
        expect(subject).to receive(:user).at_least(1).and_return(user)
        expect(subject.to).to eq('User Name <user@email.com>')
      end
    end

    context "when user does not have a name" do
      it "returns email and name" do
        subject = HelloUser.new(to: 'some@email.com')
        user = double(email: 'user@email.com')
        expect(subject).to receive(:user).at_least(1).and_return(user)
        expect(subject.to).to eq('user@email.com')
      end
    end
  end
end

describe Gossiper::Notification do
  before do
    Gossiper.configure do |config|
      config.default_from     = 'from@email.com'
      config.default_reply_to = 'replyto@email.com'
      config.default_cc       = ['cc@email.com']
      config.default_bcc      = ['bcc@email.com']
    end
  end

  subject { HelloUser.new }
  let(:config)        { Gossiper.configuration }

  its(:template_name) { should eq('hello_user') }
  its(:template_path) { should eq('') }
  its(:subject)       { should eq(I18n.t('gossiper.notifications.hello_user.subject')) }
  its(:from)          { should eq(config.default_from) }
  its(:cc)            { should eq(config.default_cc) }
  its(:bcc)           { should eq(config.default_bcc) }
  its(:attachments)   { should eq({}) }
  its(:instance_variables){ should eq({}) }
  its(:subject_variables) { should eq({}) }
end

describe Hello do
  it "persists correctly" do
    expect do
      expect do
        subject.save!(validate: false)
      end.to change(Gossiper::Notification, :count).by(1)
    end.to change(Hello, :count).by(1)
  end

  it { should_not validate_presence_of(:user) }
end

describe HelloUser do
  it "persists correctly" do
    expect do
      expect do
        subject.save!(validate: false)
      end.to change(Gossiper::Notification, :count).by(1)
    end.to change(HelloUser, :count).by(1)
  end


  it { should validate_presence_of(:user) }
end

