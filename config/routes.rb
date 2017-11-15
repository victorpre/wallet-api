Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update]
      as :user do
        post '/signin', to: 'sessions#create'
        delete '/signout', to: 'sessions#destroy'
      end
      namespace :me do
        resource :wallet, only: [:show, :update] do
          resource :cards, only: [:create, :destroy], controller: 'credit_cards'
        end
      end
    end
  end
end
