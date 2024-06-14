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
    get 'users/search'
  end  

  resources :customers, except: [:show]
  get 'customers/search'

  get 'cities/index'
  get 'cities/search'
  get 'cities/filter'  

  resources :positions, except: [:show]  
  get 'positions/search'  

  resources :systems, except: [:show]
  get 'systems/search'

end
