Rails.application.routes.draw do

  get 'leads/new'
  get 'leads/index'
  get 'leads/create'
  get 'leads/show'
  get 'leads/edit'
  get 'leads/update'
  get 'leads/destroy'

  post 'columns' => 'columns#create'
  put 'column/:id' => 'columns#update'
  delete 'column/:id' => 'columns#destroy'

  post '/boards' => 'boards#create'
  get '/board/:id' => 'boards#show'
  put 'board/:id' => 'boards#update'
  delete 'board/:id' => 'boards#destroy'

  post 'users' => 'users#create'
  get 'user/:id' => 'users#show'
  put 'user/:id' => 'users#update'
  delete 'user/:id' => 'users#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
