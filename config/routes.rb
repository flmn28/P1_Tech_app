Rails.application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    get 'login', to: 'devise/sessions#new'
    get 'sign_up' => 'devise/registrations#new'
    get 'logout' => 'devise/sessions#destory'
  end
  resources :users, only:[:new,:index,:show, :edit, :update]

  root to: 'top#index'

  resources :posts do

    member do
      post 'support' => 'posts#support'
      post 'join' => 'posts#join'
      get 'approve' => 'posts#approve'
      delete 'leave' => 'posts#leave'
      get 'success' => 'posts#success'

      post 'create_comment' => 'posts#create_comment'
      delete 'destroy_comment/:comment_id' => 'posts#destroy_comment'
    end
    collection do
      get 'search' => 'posts#search'
    end
  end

  get 'talk_room/:post_id' => 'group_messages#talk_room', as: 'talk_room'
  post 'group_messages/:post_id' => 'group_messages#create', as: 'create_group_message'
  delete 'group_messages/:id/:post_id' => 'group_messages#destroy', as: 'destroy_group_message'

  get 'evaluations/new/:post_id/:user_id' => 'evaluations#new', as: 'new_evaluation'
  post 'evaluations/:post_id/:user_id' => 'evaluations#create', as: 'create_evaluation'

  get '/top', to: 'top#index'

end
