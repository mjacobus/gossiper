require "spec_helper"


describe Gossiper, ".configuration" do
  subject { Gossiper }

  it "returns a Configuration" do
    expect(subject.configuration).to be_a(Gossiper::Configuration)
  end

  it "memoizes value" do
    config = subject.configuration
    expect(subject.configuration).to be(config)
  end
end

describe Gossiper, ".config" do
  it "yields the configuration" do
    configuration = Gossiper.configuration
    configuration.should_receive(:respond_to?).with(:method)

    config = subject.config do |config|
      config.respond_to?(:method)
    end
  end
end
