require "spec_helper"

class DynamicData < Gossiper::Notification
  dynamic_attributes :name, :some_data
end

describe Gossiper::Concerns::Models::DynamicAttributes, ".dynamic_attributes" do


  subject do
    rec = DynamicData.create!({
      name: 'Name',
      some_data: 'some value'
    })
  end

  it "saves the data dynamically" do
    expect(subject.name).to eq('Name')
    expect(subject.some_data).to eq('some value')
  end

end
