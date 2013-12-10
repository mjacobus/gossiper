module Gossiper
  class ApplicationController < ActionController::Base

    if respond_to?(:before_action)
      before_action :gossiper_authorization
    else
      before_filter :gossiper_authorization
    end

    def gossiper_authorization
      instance_eval(&Gossiper.configuration.authorize_with)
    end

    def page
      params[:page].presence || 1
    end

    def per_page
      params[:per_page].presence ||  25
    end
  end
end
