Rails.application.routes.draw do
  root to: "panels#index"

  devise_for :admins, controllers: { registrations: 'admins/registrations' }
  devise_for :users, controllers: { registrations: 'users/registrations' }

  Sfhelpdesk::Application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/email" if Rails.env.development?
    # mount Sidekiq::Web => '/sidekiq'
  end  

  namespace :employee do
    resources :users, except: [:show]
  end  

  resources :customers, except: [:show]

  get 'cities/index'
  get 'cities/filter'  

  resources :positions, except: [:show]
  resources :systems, except: [:show]
  resources :topics, except: [:show]  

  resources :sub_topics, except: [:show, :new]
  get 'sub_topics/new/:topic_id', to: 'sub_topics#new', as: 'new_sub_topic'

end
