Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "login", to: "auth#login"
      post "signup", to: "auth#register"
      patch "profile", to: "auth#update"
    end
  end
end
