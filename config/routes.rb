Rails.application.routes.draw do
  

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root 'posts#index'

  resources :users, only: [:new, :create]
  resource :user, only: [:edit, :update]
  resource :sessions, only: [:new, :create, :destroy]


  resources :posts do

    resources :comments, shallow: true, only: [:create, :destroy]

  end

end
