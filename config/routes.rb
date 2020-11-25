Rails.application.routes.draw do
  root "home#top"
  get "about_user", :to => "home#about_user"
  get "about_hospital", :to => "home#about_hospital"

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  devise_for :hospitals, controllers: {
    registrations: "hospitals/registrations",
    sessions: "hospitals/sessions"
  }

  scope module: :users do
    get "sign_up", :to => "users/registrations#new"
    get "sign_in", :to => "users/sessions#new"
    get "sign_out", :to => "users/sessions#destroy"
    resources :users, only: [:show, :edit, :update]
    resources :daily_records
  end

  scope module: :hospitals do
    get "sign_up", :to => "hospitals/registraions#new"
    get "sign_in", :to => "hospitals/sessions#new"
    get "sign_out", :to => "hospitals/sessions#destroy"
    resources :hospitals, only: [:index, :show, :edit, :update]
  end

  namespace :hospitals do
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
