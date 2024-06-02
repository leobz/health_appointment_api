Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  namespace :api do
    namespace :v1 do

      resources :doctors, only: [:show] do
        resources :working_hours, only: [:index], module: :doctors
      end
    end
  end
end
