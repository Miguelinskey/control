Rails.application.routes.draw do
  get  "sign_up", to: "registrations#new"
  post "sign_up", to: "registrations#create"
  get  "login",   to: "sessions#new"
  post "login",   to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  get "users/check_username", to: "registrations#check_username"

  namespace :admin do
    root to: redirect("/admin/categories")
    resources :categories, except: [:show]
    resources :users, only: [:index, :edit, :update, :destroy]
  end

  resources :categories, only: [:index, :show], path: "c", param: :slug do
    resources :topics, except: [:index] do
      member do
        patch :lock
        patch :pin
      end
      resources :posts, only: [:create, :edit, :update, :destroy]
    end
  end

  root "categories#index"
end
