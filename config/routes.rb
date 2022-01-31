Rails.application.routes.draw do
  root to: 'pages#index'
  resources :posts
  get 'pages/index'
  post 'login_as', controller: 'application'
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
