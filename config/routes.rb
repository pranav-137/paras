Rails.application.routes.draw do
  # get "bookings/new"
  # get "bookings/create"
  # get "bookings/index"
  # get "bookings/show"
  # Devise
devise_for :users, controllers: {
  registrations: 'users/registrations',
  sessions: 'users/sessions'
}, path_names: { sign_in: 'login', sign_out: 'logout' }, skip: [:confirmations]

  # Static
  root "home#index"
  get "about", to: "home#about"
  get "gallery", to: "home#gallery"
  get "contact", to: "home#contact"
  post "send_message", to: "home#send_message"
  get "oauth2callback", to: "home#oauth2callback"
  get '/authorize_gmail', to: 'home#authorize_gmail'


  # Admin
  get "admin", to: "dashboard#index"

  # Resources
  resources :tenants
  # config/routes.rb
resources :owners
resources :ownerdocs, only: [:new, :create, :edit, :update, :index, :show, :destroy]
resources :properties, only: [:new, :create, :edit, :update, :show, :index, :destroy] do
  member do
    get :details  # ✅ adds /properties/:id/details
  end
end

resources :tenantdocs
resources :bookings



end