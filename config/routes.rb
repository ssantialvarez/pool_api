Rails.application.routes.draw do
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"
  post "auth/register" => "auth0#register"
  get "auth/callback" => "auth0#callback"
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Players endpoints
  get "players/me" => "players#show"
  get "players" => "players#index"
  patch "players/me" => "players#update"
  put "players/me" => "players#update"
  delete "players/:id" => "players#destroy"
  post "players" => "players#create"

  # Matches endpoints
  post "matches" => "matches#create"
  get "matches" => "matches#index"
  put "matches/:id" => "matches#update"
  patch "matches/:id" => "matches#update"
  get "matches/:id" => "matches#show"
  delete "matches/:id" => "matches#destroy"
end
