Rails.application.routes.draw do
  if Rails.env.development?
    mount GraphiQL::Rails::Engine, at: "/graphiql", graphql_path: "/graphql"
  end
  post "/graphql", to: "graphql#execute"
  resources :events
  resources :participants
  get "my_participations", action: :user_index, controller: "participants"

  devise_for :users, path: "", path_names: {
    sign_in: "login",
    sign_out: "logout",
    registration: "signup"
  },
  controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations"
  }

  # post "api/v1/users/login", to: "api/v1/users/sessions#new"
  # post "api/v1/users/signup", to: "api/v1/users/registrations#new"

  scope "/api", defaults: { format: :json } do
    scope "/v1" do
      scope "/users" do
        devise_for :users, as: :user_api, path: "", path_names: {
          sign_in: "login", sign_out: "logout", registration: "signup"
        }, controllers: {
          registrations: "api/v1/users/registrations",
          sessions: "api/v1/users/sessions"
        }
        devise_scope :user do
          get "users/current", to: "api/v1/users/sessions#show"
        end

        resources :pages, only: %i[index]
      end

      resources :events, as: :api_events, controller: "api/v1/events/events"
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/*
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Defines the root path route ("/")
  root "home#index"

  devise_scope :user do
    get "/users/sign_out" => "devise/sessions#destroy"
  end
end
