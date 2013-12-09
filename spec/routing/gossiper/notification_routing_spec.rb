require 'spec_helper'

describe Gossiper::NotificationsController, '#routing' do
  routes { Gossiper::Engine.routes }

  it "routes to #index" do
    expect(get('/')).to route_to('gossiper/notifications#index')
    expect(get('/notifications')).to route_to('gossiper/notifications#index')
    expect(notifications_path).to eq("/gossiper/notifications")
  end

  it "routes to #show" do
    expect(get('/notifications/1')).to route_to('gossiper/notifications#show', id: '1')
  end

  it "routes to #detroy" do
    expect(delete('/notifications/1')).to route_to('gossiper/notifications#destroy', id: '1')
  end

  it "routes to #deliver" do
    expect(post('/notifications/1/deliver')).to route_to('gossiper/notifications#deliver', id: '1')
  end

end
