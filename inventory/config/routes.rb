Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy 
  end

  resources :users
  resources :items

  get '/', to: 'items#index'
  get '/ΚΤ/:serial', to:'items#show' #ΚΤ in greek letters
  get '/KT/:serial', to:'items#show' #KT in english letters

  get 'not_found', to: 'items#not_found'
  get 'picture', to: 'items#picture'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
