Rails.application.routes.draw do

  post 'lead_emails' => 'lead_emails#create'
  get 'lead_email/:id' => 'lead_emails#show'
  put 'lead_email/:id' => 'lead_emails#update'
  delete 'lead_email/:id' => 'lead_emails#destroy'

  post 'job_positions' => 'job_positions#create'
  get 'job_position/:id' => 'job_positions#show'
  put 'job_position/:id' => 'job_positions#update'
  delete 'job_position/:id' => 'job_positions#destroy'

  post 'leads' => 'leads#create'
  get 'lead/:id' => 'leads#show'
  put 'lead/:id' => 'leads#update'
  delete 'lead/:id' => 'leads#destroy'


  post 'columns' => 'columns#create'
  put 'column/:id' => 'columns#update'
  delete 'column/:id' => 'columns#destroy'

  post 'boards' => 'boards#create'
  get 'board/:id' => 'boards#show'
  put 'board/:id' => 'boards#update'
  delete 'board/:id' => 'boards#destroy'

  post 'users' => 'users#create'
  get 'user/:id' => 'users#show'
  put 'user/:id' => 'users#update'
  delete 'user/:id' => 'users#destroy'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
