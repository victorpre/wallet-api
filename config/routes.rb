Rails.application.routes.draw do
  devise_for :users

  namespace :api do
    namespace :v1 do
      resources :users, only: [:show, :create, :update]
    end
  end
end
