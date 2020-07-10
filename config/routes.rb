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

  get 'boards/new'
  get 'boards/index'
  get 'boards/create'
  get 'boards/show'
  get 'boards/edit'
  get 'boards/update'
  get 'boards/destroy'

  post 'users/new' => 'users#new'
  get 'users/index' => 'users#index'
  post 'users/create' => 'users#create'
  get 'users/show/:id' => 'users#show'
  put 'users/update/:id' => 'users#update'
  delete 'users/destroy/:id' => 'users#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
