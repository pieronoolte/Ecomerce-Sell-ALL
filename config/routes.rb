Rails.application.routes.draw do
  namespace :authentication, path: '', as: '' do
    resources :users, only: [:new, :create], path: '/register', path_names: { new: '/'}
    resources :sessions, only: [:new, :create, :destroy], path: '/login', path_names: { new: '/'}
  end

  resources :favorites, only: [:index, :create, :destroy], param: :product_id
  resources :users, only: :show, path: '/user', param: :username
  resources :categories, except: :show
  resources :products, path: '/'
  # get "up" => "rails/health#show", as: :rails_health_check
  get '/up', to: 'products#up'


end

# get 'products/new', to: 'products#new', as: :new_product
# get '/products', to: 'products#index'
# get '/products/:id', to: 'products#show', as: :product
# post '/products', to: 'products#create'
# get '/products/:id/edit', to: 'products#edit', as: :edit_product
# patch '/products/:id', to: 'products#update'
# delete '/products/:id', to: 'products#destroy'