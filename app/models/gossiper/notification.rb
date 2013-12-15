module Gossiper
  class Notification < ActiveRecord::Base
    include Gossiper::Concerns::Models::Notification
  end
end
