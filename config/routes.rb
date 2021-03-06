Rails.application.routes.draw do
  root "home#top"
  post "/home/user_guest_sign_in", :to => "home#new_user_guest"
  post "/home/hospital_guest_sign_in", :to => "home#new_hospital_guest"
  get "about_user", :to => "home#about_user"
  get "about_hospital", :to => "home#about_hospital"
  resources :chats, only: [:create, :show], param: :room_id
  resources :rooms, only: [:create]

  scope module: :users do
    devise_for :users, controllers: {
      registrations: "users/registrations",
      sessions: "users/sessions",
    }
    get "daily_records/search", :to => "daily_records#search"
    resources :users, only: [:show, :edit, :update, :destroy] do
      get "delete_confirm", :to => "users#delete_confirm"
      resources :medical_histories, except: [:show]
      resources :health_cares, except: [:show]
      get :families, on: :member
      resources :medical_records
    end
    resources :daily_records do
      resource :favorites, only: [:create, :destroy]
      resources :comments, only: [:create, :destroy]
    end
  end

  scope module: :hospitals do
    devise_for :hospitals, controllers: {
      registrations: "hospitals/registrations",
      sessions: "hospitals/sessions",
    }
    get "hospitals/search", :to => "search#search"
    resources :hospitals, only: [:index, :show, :edit, :update]
    resources :medical_relationships, only: [:create, :destroy]
  end

  if Rails.env.development?
    mount LetterOpenerWeb::Engine, at: '/letter_opener'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
