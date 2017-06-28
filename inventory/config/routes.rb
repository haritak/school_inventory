Rails.application.routes.draw do
  get 'admin' => 'admin#index'

  controller :sessions do
    get 'login' => :new
    post 'login' => :create
    delete 'logout' => :destroy 
  end

  resources :users
  resources :items
  resources :item_categories

  get '/', to: 'items#index'
  get '/KT/:serial', to:'items#show' #KT in english letters
  get '/RM/:serial', to:'items#show' #Rooms
  get '/I/:serial', to:'items#show' #I english letters Items
  get '/VP/:serial', to:'items#show' #I english letters Virtual Places

  get 'not_found', to: 'items#not_found'
  get 'picture', to: 'items#picture'
  get 'second_picture', to: 'items#second_picture'
  get 'invoice', to: 'items#invoice'

  get '/upload_photo', to: 'items#upload_photo'
  post '/upload_photo', to: 'items#search_and_place_photo'

  get '/toggle_show_all_mine', to: 'items#toggle_show_all_mine'

  get '/movements', to: 'item_movements#index'

  get '/categories', to: 'item_categories#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
