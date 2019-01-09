Rails.application.routes.draw do
  root to: 'vehicles#index'
  get '/vehicles/new', to: 'vehicles#new'
  post '/vehicles/new', to: 'vehicles#create'
  get '/vehicles/edit/:id', to: 'vehicles#edit'
  patch '/vehicles/edit/:id', to: 'vehicles#update'
end
