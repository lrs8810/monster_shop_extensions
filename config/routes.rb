# frozen_string_literal: true

Rails.application.routes.draw do
  get '/', to: 'items#index', as: 'welcome'

  resources :items, except: %i[new create] do
    resources :reviews, only: %i[new create]
  end

  resources :merchants do
    resources :items, only: %i[new create index]
  end

  resources :reviews, only: %i[edit update destroy]

  resources :orders, only: %i[new create show]

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/profile', to: 'users#show'
  get '/profile/edit', to: 'users#edit_profile'
  get '/profile/edit_password', to: 'users#edit_password'
  patch '/profile/update', to: 'users#update_profile'
  patch '/profile/update_password', to: 'users#update_password'

  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/:id', to: 'user_orders#show', as: 'profile_order'
  patch '/profile/orders/:id', to: 'user_orders#update'

  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create', as: 'login_create'
  delete '/logout', to: 'sessions#logout'

  namespace :admin do
    get '/', to: 'dashboard#index'
    get '/users', to: 'users#index'
    get '/users/:user_id', to: 'users#show'
    patch '/users/:user_id', to: 'users#toggle_enabled'
    get '/users/:user_id/edit', to: 'users#edit_profile'
    patch '/users/:user_id/update', to: 'users#update_profile', as: 'update_user_profile'
    get '/users/:user_id/orders/:order_id', to: 'user_orders#show', as: 'user_order'
    patch '/users/:user_id/orders/:order_id', to: 'user_orders#update', as: 'user_order_update'
    patch '/orders/:order_id', to: 'dashboard#update_order_status'
    get '/merchants/:merchant_id', to: 'merchants#show', as: 'merchants'
    patch '/merchants/:merchant_id', to: 'merchants#toggle_enabled'
  end

  namespace :merchant do
    get '/', to: 'dashboard#index', as: 'dashboard'
    get '/items', to: 'items#index', as: 'user_items'

    get '/orders/:order_id', to: 'orders#show', as: 'orders'
    patch '/orders/:order_id/:item_order_id/fulfill', to: 'orders#update_item'

    get '/items/new', to: 'items#new'
    get '/items/:item_id/edit', to: 'items#edit', as: 'items_edit'
    post '/items', to: 'items#create'
    patch '/items/:item_id', to: 'items#update', as: 'items_update'
    patch '/items/:item_id/activate_deactivate/:activate_deactivate', to: 'items#activate_deactivate', as: 'items_activate_deactivate'
    patch '/items/disable/:item_id', to: 'items#disable_item', as: 'item_disable'
  end
end
