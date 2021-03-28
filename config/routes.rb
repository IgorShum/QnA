Rails.application.routes.draw do

  devise_for :users
  root to: 'questions#index'
  resources :questions do
    resources :answers, shallow: true, except: %i[index new show] do
      member do
        post :best
      end
    end
  end

  resources :attachments, only: :destroy
end
