module Gossiper
  module Concerns
    module Models
      module EmailSettings
        extend ActiveSupport::Concern

        def from
          config.default_from
        end

        def reply_to
          config.default_reply_to.presence || config.default_from
        end

        def bcc
          config.default_bcc
        end

        def cc
          config.default_cc
        end

        def template_name
          type.underscore
        end

        def template_path
          ''
        end

        def subject
          I18n.t("gossiper.notifications.#{type.underscore}.subject", subject_variables)
        end

        def attachments
          {}
        end

        def instance_variables
          {}
        end

        def subject_variables
          {}
        end

        def deliver
          mail.deliver
          update_delivered_at!
        end

        def deliver!
          mail.deliver!
          update_delivered_at!
        end

        def config
          Gossiper.configuration
        end

      end
    end
  end
end
