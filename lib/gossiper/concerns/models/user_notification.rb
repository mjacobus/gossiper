module Gossiper
  module Concerns
    module Models
      module UserNotification
        extend ActiveSupport::Concern

        included do
          validates :user, presence: true
        end

      end
    end
  end
end
