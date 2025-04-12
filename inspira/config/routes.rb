# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :site do
    get "home/index"
  end
  namespace :users_backoffice do
    get "welcome/index"
    resources :clients do
      get "index_api", on: :collection
    end
    resources :list_services
    resources :cash_registers, only: [] do
      collection do
        get "index"
        get "releases/bills_to_pay", to: "cash_registers#bills_to_pay"
        resources :bills_to_pays
        resources :categories_accounts_payables, path: "categories_accounts_payables"
        resources :cash_flows, only: [:index, :new, :create, :edit, :update, :destroy] do
          collection do
            get "received", to: "cash_flows#received"
            get "search", to: "cash_flows#search"
          end
        end
      end
    end
  end
  namespace :admins_backoffice do
    resources :welcome, only: [:index]
    resources :clients do
      get "search", on: :collection
      get "show_client", on: :member
      get "phones", on: :member
      get "emails", on: :member
      get "addresses", on: :member
    end
    resources :services
    resources :list_services
    resources :cash_registers, only: [] do
      collection do
        get "index"
        # get "releases/bills_to_pay", to: "cash_registers#bills_to_pay"
        resources :bills_to_pays do
          collection do
            get :filter, to: "bills_to_pays#filter"
          end
        end
        resources :categories_accounts_payables
        resources :cash_flows, only: [:index, :new, :create, :edit, :update, :destroy] do
          collection do
            get "received", to: "cash_flows#received"
            get "search", to: "cash_flows#search"
          end
        end
        resources :invoicings, only: [:index]
      end
      member do
        post :add_payment, to: "bills_to_pays#add_payment"
        patch :save_payment, to: "bills_to_pays#save_payment"
      end
    end
    resources :profiles, only: [:index] do
      patch "update_password", on: :collection
      patch "update_profile", on: :collection
      get "edit_password", on: :collection
      get "edit_profile", on: :collection
    end
  end

  devise_for :users
  devise_for :admins

  devise_scope :admin do
    root to: "devise/sessions#new"
  end

  resources :clients

  resources :phones

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  get "inicio", to: "site/home#index"

  # Defines the root path route ("/")
  # root "site/home#index"
end
