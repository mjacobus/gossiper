require 'spec_helper'

describe "Dummy application user" do
  subject { User.new }
  it { should respond_to(:name) }
  it { should respond_to(:email) }
end
