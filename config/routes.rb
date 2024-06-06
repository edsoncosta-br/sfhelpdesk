Rails.application.routes.draw do
  get 'positions/index'
  get 'customers/index'
  root to: "panels#index"

  devise_for :admins
  devise_for :users

  Sfhelpdesk::Application.routes.draw do
  get 'positions/index'
  get 'customers/index'
  get 'cities/index'
    mount LetterOpenerWeb::Engine, at: "/email" if Rails.env.development?
    # mount Sidekiq::Web => '/sidekiq'
  end  

  get 'cities/index'
end
