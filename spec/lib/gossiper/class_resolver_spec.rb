require "spec_helper"

describe Gossiper::ClassResolver do
  it "resolves classes" do
    expect(subject.resolve('talk_to_us')).to eq('Notifications::TalkToUsNotification')
    expect(subject.resolve('contact')).to eq('Notifications::ContactNotification')
    expect(subject.resolve('contacts')).to eq('Notifications::ContactsNotification')
  end
end
