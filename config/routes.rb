require 'sidekiq/web'
require 'sidekiq/cron/web'

Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "up" => "rails/health#show", as: :rails_health_check

  authenticate :admin_user do
    mount Sidekiq::Web => "/sidekiq"
  end

  mount ActionCable.server => "/cable"

  root to: "api/welcomes#index"

  namespace :api do
    namespace :v1 do
      resource :session, only: [] do
        collection do
          post 'login_with_password'
          post 'login_with_otp'
        end
      end
      resource :password, only: %i[create]
      resources :users, only: %i[index create show update destroy] do
        resources :direct_messages, only: %i[index create update destroy] do
          # collection do
          #   get 'conversations_user_list'
          # end
        end
      end
      resources :direct_messages, only: %i[] do
        collection do
          get 'conversations_user_list'
        end
      end
      resource :otp, only: %i[create]
      resources :posts, only: %i[index create show update destroy]
      resources :comments, only: %i[index create show update destroy]
      resources :likes, only: %i[index create]
      resources :views, only: %i[index create]
      resource :follow, only: %i[create]
      resources :groups, only: %i[index create show update destroy] do
        resources :group_members, only: %i[index create destroy]
        resources :group_messages, only: %i[index create update destroy]
      end
      resources :moments, only: %i[index create show update destroy]
      resource :profile, only: [] do
        collection do
          get 'my_posts'
          get 'my_comments'
          get 'my_like_posts'
          get 'my_like_comments'
          get 'my_followers'
          get 'my_followings'
          get 'my_groups'
          get 'my_moments'
        end
      end

      resources :public_profiles, only: %i[show] do
        member do
          get 'posts'
          get 'comments'
          get 'like_posts'
          get 'like_comments'
          get 'followers'
          get 'followings'
          get 'groups'
          get 'moments'
        end
      end

      resources :blobs, only: %i[create]
    end
  end
end
