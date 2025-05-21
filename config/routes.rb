Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "auth#login"
      post "signup", to: "auth#register"
      patch "profile", to: "auth#update"

      resources :users, only: [ :index, :show, :create, :update, :destroy  ] do
        resources :tasks, only: [ :index, :show, :create, :update, :destroy ]
      end
    end
  end
end
