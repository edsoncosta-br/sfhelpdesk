Rails.application.routes.draw do
  root to: "panels#index"

  devise_for :admins, controllers: { registrations: 'admins/registrations' }
  devise_for :users, controllers: { registrations: 'users/registrations' }

  Sfhelpdesk::Application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/email" if Rails.env.development?
    # mount Sidekiq::Web => '/sidekiq'
  end  

  # get 'cities/index'
  get 'cities/filter'  
  get 'dependencies/project_responsible'

  namespace :employee do
    resources :users
  end

  namespace :ajuda do
    get 'artigo/:id', to: 'artigo#show', as: 'artigo_show'
  end  

  resources :customers
  resources :positions
  resources :projects
  resources :tags
  resources :marks
  get	'marks/:id/close', to: 'marks#close', as: 'close_mark'
  put	'marks/:id/reopen', to: 'marks#reopen', as: 'reopen_mark'

  resources :requests
  put 'requests/delete_attachment/:id_attachment/:id_request', to: 'requests#delete_attachment', as: 'requests_delete_attachment'
  put 'requests/status_finished/:id_request', to: 'requests#status_finished', as: 'requests_status_finished'
  put 'requests/status_archived/:id_request', to: 'requests#status_archived', as: 'requests_status_archived'
  put 'requests/status_reopen/:id_request', to: 'requests#status_reopen', as: 'requests_status_reopen'
  put 'requests/step_wait/:id_request', to: 'requests#step_wait', as: 'requests_step_wait'
  put 'requests/step_execute/:id_request', to: 'requests#step_execute', as: 'requests_step_execute'
  put 'requests/step_finish/:id_request', to: 'requests#step_finish', as: 'requests_step_finish'

  resources :request_comments, except: [:show, :index]

  resources :helps

end
