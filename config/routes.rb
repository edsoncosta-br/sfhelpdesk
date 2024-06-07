Rails.application.routes.draw do
  root to: "panels#index"

  devise_for :admins
  devise_for :users

  Sfhelpdesk::Application.routes.draw do
    mount LetterOpenerWeb::Engine, at: "/email" if Rails.env.development?
    # mount Sidekiq::Web => '/sidekiq'
  end  

  get 'positions/index'
  get 'customers/index'  

  get 'cities/index'
  get 'cities/search'
  get 'cities/filter'  

  get 'positions/index'
  get 'positions/search'  
end
