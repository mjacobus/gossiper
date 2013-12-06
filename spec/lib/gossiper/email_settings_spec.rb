require 'spec_helper'

describe Gossiper::EmailSettings do
  subject { described_class.new(notification) }

  let(:user)         { double(:user, email: 'user@email.com', name: 'User Name') }
  let(:notification) { double(:notification, user: user, kind: 'user_welcome') }
  its(:user)         { should be(user) }
  its(:notification) { should be(notification) }
  its(:cc)           { should be_empty }
  its(:bcc)          { should be_empty }

  describe "#to" do
    context "when user has a name" do
      its(:to) { should eq(['User Name <user@email.com>']) }
    end

    context "when user does not have a name" do
      let(:user) { double(:user, email: 'nameless@email.com') }
      its(:to)   { should eq(['nameless@email.com']) }
    end
  end


  describe "#template" do
    it "defaults to notifications/type" do
      expect(subject.template).to eq('notifications/user_welcome')
      notification.stub(kind: 'another_kind')
      expect(subject.template).to eq('notifications/another_kind')
    end
  end

end
