Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get 'notifications/index'

  resources :posts do
    resources :comments  
  end
  get 'search', to: 'search#search'

  resources :likes do
    member do
      put "like", to: "likes#like"
      put "unlike", to: "likes#unlike"
    end
  end

  # match :like, to: 'likes#like', as: :like, via: :post
  # match :unlike, to: 'likes#unlike', as: :unlike, via: :post

  get 'home/index'

  # devise_for :users
  # devise_scope :user do
  #   get '/users/auth/:provider' => 'users/omniauth_callbacks#passthru'
  # end
  devise_for :users, :controllers =>
      {
        omniauth_callbacks: 'users/omniauth_callbacks',
        registrations: 'registrations'
      }

  resources  :users, :only => [:index, :show] do
    member do
      get :following, :followers
    end
  end

  resources :relationships,       only: [:create, :destroy]
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'home#index'
  mount ActionCable.server => '/cable'

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :home
      resources :posts do
        resources :comments
      end
    end
  end

  get '/api' => redirect('/swagger-ui/dist/index.html?url=/apidocs/api-docs.json')
end
