Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update]
      as :user do
        post '/signin', to: 'sessions#create'
        delete '/signout', to: 'sessions#destroy'
      end
      get '/wallet', to: 'wallets#show'
      put '/wallet/limit', to: 'wallets#limit'
    end
  end
end
