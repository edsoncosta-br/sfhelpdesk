Rails.application.routes.draw do
  root to: "panels#index"

  devise_for :admins, controllers: { registrations: 'admins/registrations' }
  devise_for :users, controllers: { registrations: 'users/registrations' }

  Sfhelpdesk::Application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/email" if Rails.env.development?
    # mount Sidekiq::Web => '/sidekiq'
  end  

  get 'cities/index'
  get 'cities/filter'  

  namespace :employee do
    resources :users, except: [:show]
  end  

  resources :customers, except: [:show]  
  resources :positions, except: [:show]
  resources :projects, except: [:show]
  get 'projects/filter_project_dependency'
  resources :tags, except: [:show]
  resources :marks, except: [:show]
  resources :requests
  put 'requests/delete_attachment/:id_attachment/:id_request', to: 'requests#delete_attachment', as: 'requests_delete_attachment'

end
