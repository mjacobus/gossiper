require 'spec_helper'

describe Gossiper::EmailConfig do
  subject { described_class.new(notification) }

  let(:user)         { double(:user, email: 'user@email.com', name: 'User Name') }
  let(:notification) { double(:notification, user: user, kind: 'user_welcome') }
  its(:user)         { should be(user) }
  its(:notification) { should be(notification) }
  its(:cc)           { should be_empty }
  its(:bcc)          { should be_empty }
  its(:from)         { should be_nil }
  its(:subject)      { should eq(I18n.t('gossiper.notifications.user_welcome.subject')) }
  its(:attachments)  { should eq({}) }
  its(:template_name){ should eq('user_welcome_notification') }
  its(:template_path){ should eq('notifications') }
  its(:instance_variables){ should eq({}) }

  describe "#to" do
    context "when user has a name" do
      its(:to) { should eq(['User Name <user@email.com>']) }
    end

    context "when user does not have a name" do
      let(:user) { double(:user, email: 'nameless@email.com') }
      its(:to)   { should eq(['nameless@email.com']) }
    end
  end

end
