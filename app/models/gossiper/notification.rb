module Gossiper
  class Notification < ActiveRecord::Base
    include Gossiper::Concerns::Models::Notification
    include Gossiper::Concerns::Models::DynamicAttributes
  end
end
