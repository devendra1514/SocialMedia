Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  get "up" => "rails/health#show", as: :rails_health_check

  root to: "api/homes#index"

  namespace :api do
    namespace :v1 do
      resource :session, only: [] do
        collection do
          post 'login_with_password'
          post 'login_with_otp'
        end
      end
      resource :password, only: %i[new create]
      resources :users, only: %i[index create show update destroy]
      resource :otp, only: %i[new create]
      resources :posts, only: %i[index create show update destroy]
      resources :comments, only: %i[index create show update destroy]
      resource :like, only: %i[create]
      resource :follow, only: %i[create]
      resource :profile, only: [] do
        collection do
          get 'my_posts'
          get 'my_comments'
          get 'my_like_posts'
          get 'my_like_comments'
          get 'my_followers'
          get 'my_followings'
        end
      end

      resources :public_profiles, only: [] do
        member do
          get 'posts'
          get 'comments'
          get 'like_posts'
          get 'like_comments'
          get 'followers'
          get 'followings'
        end
      end
    end
  end
end
