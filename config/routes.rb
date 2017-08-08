Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'admin#show', as: :admin
  patch '/', to: 'admin#update'
  # resource :admin, controller: 'admin'
  resource :feed, controller: 'feed'
end
