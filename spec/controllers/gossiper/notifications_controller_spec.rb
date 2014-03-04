require 'spec_helper'


describe Gossiper::NotificationsController do
  render_views
  routes { Gossiper::Engine.routes }

  before do
    Gossiper.configuration.authorize_with do

    end
  end

  let(:user) { User.create!(name: 'Name', email: 'user@email.com') }

  let(:notification) do
    n      = UserNotification.new
    n.user = user
    n.save!
    n
  end

  describe "#index" do
    it "lists all the notifications" do
      notification
      get :index
      expect(response).to be_success
      expect(assigns(:notifications)).to eq([notification])
      expect(response).to render_template(:index)
    end
  end

  describe "#show" do
    it "shows the notification" do
      get :show, id: notification.id
      expect(response).to be_success
      expect(assigns(:notification)).to eq(notification)
      expect(response).to render_template(:show)
    end
  end

  describe "#deliver" do
    it "deliveres a message" do
      mail = double(deliver!: true)
      Gossiper::Mailer.should_receive(:mail_for).with(notification).and_return(mail)
      post :deliver, id: notification.id
    end

    it "redirects to the index page" do
      post :deliver, id: notification.id
      expect(response).to redirect_to(notifications_path)
    end
  end

  describe "#verify_permissions" do
    it "verifies permissions" do
      Gossiper.configuration.authorize_with do |controller|
        controller.redirect_to controller.root_path, notice: 'no way dude.'
      end

      get(:index)
      expect(response).to redirect_to(root_path)
    end
  end
end
