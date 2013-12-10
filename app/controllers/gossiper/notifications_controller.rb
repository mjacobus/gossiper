require_dependency "gossiper/application_controller"

module Gossiper
  class NotificationsController < ApplicationController
    respond_to :html

    def index
      @notifications = Notification.order('id desc').page(page).per(per_page)
      respond_with(@notifications)
    end

    def show
      respond_with(notification)
    end

    def deliver
      notification.deliver!
      respond_with(notification) do |format|
        format.html { redirect_to :notifications, notice: t('.delivered')  }
      end
    end

    private
      def notification
        @notification ||= Notification.find(params[:id])
      end
  end
end
