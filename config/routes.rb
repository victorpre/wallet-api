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
          post '/purchase', to: 'purchases#create', as: 'create_purchase'
          resource :cards, only: [:create, :destroy], controller: 'credit_cards' do
            post '/:id/pay', to: 'payments#create', as: 'create_payment'
          end
        end
      end
    end
  end
end
