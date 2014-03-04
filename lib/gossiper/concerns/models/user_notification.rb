module Gossiper
  module Concerns
    module Models
      module UserNotification
        extend ActiveSupport::Concern

        included do
          validates :user, presence: true
        end

        def to
          if user.present?
            if user.respond_to?(:name) && user.name.present?
              "#{user.name} <#{user.email}>"
            else
              user.email
            end
          end
        end

      end
    end
  end
end
