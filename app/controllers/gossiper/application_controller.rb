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
  end
end
