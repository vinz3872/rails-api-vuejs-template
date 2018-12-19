Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'

  devise_for :users,
  # skip: :omniauth_callbacks,
  defaults: { format: :json },
  path: '',
  path_names: {
   sign_in: 'login',
   sign_out: 'logout',
   registration: 'register'
   # sign_up: 'register'
 }
 # controllers: {
 #   # sessions: 'sessions',
 #   registrations: 'registrations'
 # }


 resources :pages, only: [:index]

 resources :products
end
