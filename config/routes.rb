Gossiper::Engine.routes.draw do
  root to: 'notifications#index'

  resources :notifications do
    member do
      post :deliver
    end
  end
end
