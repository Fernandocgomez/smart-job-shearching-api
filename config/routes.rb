Rails.application.routes.draw do

  get 'leads/new'
  get 'leads/index'
  get 'leads/create'
  get 'leads/show'
  get 'leads/edit'
  get 'leads/update'
  get 'leads/destroy'

  get 'columns/new'
  get 'columns/index'
  get 'columns/create'
  get 'columns/show'
  get 'columns/edit'
  get 'columns/update'
  get 'columns/destroy'

  post '/boards' => 'boards#create'
  get '/board/:id' => 'boards#show'
  put 'board/:id' => 'boards#update'
  delete 'board/:id' => 'boards#destroy'

  post 'users/new' => 'users#new'
  get 'users' => 'users#index'
  post 'users' => 'users#create'
  get 'user/:id' => 'users#show'
  put 'user/:id' => 'users#update'
  delete 'user/:id' => 'users#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
