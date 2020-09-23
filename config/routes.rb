Rails.application.routes.draw do
  root to: "home#index"
  devise_for :users
  resources :users
  resources :messages, :only => [:create]
  resources :rooms, :only => [:create, :show, :index]
end
