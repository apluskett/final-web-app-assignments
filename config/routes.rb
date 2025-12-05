Rails.application.routes.draw do
  # Serve React app for portfolio routes
  root to: proc { [200, {'Content-Type' => 'text/html'}, [File.read(Rails.root.join('public/react.html'))]] }
  get "demos", to: "pages#demos"
  get "f1_predictions", to: "pages#f1_predictions"
  post "predict_races", to: "pages#predict_races"
  
  # API endpoints for React app
  namespace :api do
    post "f1_predictions/predict", to: "pages#predict_races"
  end
  
  # Course Management System routes (traditional Rails views)
  resources :prefixes
  resources :courses
  resources :sections
  resources :students
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Cross-model search endpoint (q param)
  get "/search", to: "searches#index", as: :search
end
