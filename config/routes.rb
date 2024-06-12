Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do
      resources :doctors do
        resources :working_hours, module: :doctors
        resources :availabilities, only: [:index], module: :doctors
        resources :appointments, only: [:index], module: :doctors
      end

      resources :patients do
        resources :appointments, only: [:index], module: :patients
      end

      resources :appointments, only: [:create, :update, :destroy]
    end
  end
end
