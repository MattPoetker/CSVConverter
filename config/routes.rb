Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get '/scrape' => 'application#scrape'
  post '/upload' => 'application#upload' 
  resources :rows
  root 'application#index'
end
